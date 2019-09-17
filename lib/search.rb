require 'active_record'
require 'active_support/concern'

module Search

  def within(distance, options = {})
    @distance_column_name = "car_parks.latitude"
    @qualified_lng_column_name = "car_parks.longitude"
    options[:within] = distance
    bounds = formulate_bounds_from_distance(
        options,
        normalize_point_to_lat_lng(options[:origin]),
        options[:units] || default_units)
      with_latlng.where(bound_conditions(bounds)).
        where(distance_conditions(options))
  end

  def normalize_point_to_lat_lng(point)
    res = geocode_ip_address(point) if point.is_a?(String) && /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/.match(point)
    res = Geokit::LatLng.normalize(point) unless res
    res
  end

  def with_latlng
    where("car_parks.latitude IS NOT NULL AND car_parks.longitude IS NOT NULL")
  end

  def extract_origin_from_options(options)
    origin = options.delete(:origin)
    res = normalize_point_to_lat_lng(origin) if origin
    res
  end

  def extract_units_from_options(options)
    units = options[:units] || default_units
    options.delete(:units)
    units
  end

  def extract_formula_from_options(options)
    formula = options[:formula] || Geokit::default_formula
    options.delete(:formula)
    formula
  end

  def distance_conditions(options)
    origin  = extract_origin_from_options(options)
    units   = extract_units_from_options(options)
    formula = extract_formula_from_options(options)
    distance_column_name = distance_sql(origin, units, formula)

    if options.has_key?(:within)
      Arel.sql(distance_column_name).lteq(options[:within])
    elsif options.has_key?(:beyond)
      Arel.sql(distance_column_name).gt(options[:beyond])
    elsif options.has_key?(:range)
      min_condition = Arel.sql(distance_column_name).gteq(options[:range].begin)
      max_condition = if options[:range].exclude_end?
                        Arel.sql(distance_column_name).lt(options[:range].end)
                      else
                        Arel.sql(distance_column_name).lteq(options[:range].end)
                      end
      min_condition.and(max_condition)
    end
  end

  def bound_conditions(bounds, inclusive = false)
    return nil unless bounds
    if inclusive
      lt_operator = :lteq
      gt_operator = :gteq
    else
      lt_operator = :lt
      gt_operator = :gt
    end
    sw,ne = bounds.sw, bounds.ne
    debugger
    lat, lng = Arel.sql(@distance_column_name), Arel.sql(@qualified_lng_column_name)
    lat.send(gt_operator, sw.lat).and(lat.send(lt_operator, ne.lat)).and(
        if bounds.crosses_meridian?
          lng.send(lt_operator, ne.lng).or(lng.send(gt_operator, sw.lng))
        else
          lng.send(gt_operator, sw.lng).and(lng.send(lt_operator, ne.lng))
        end
    )
  end


  def formulate_bounds_from_distance(options, origin, units)
    distance = options[:within] if options.has_key?(:within) && options[:within].is_a?(Numeric)
    distance = options[:range].last-(options[:range].exclude_end?? 1 : 0) if options.has_key?(:range)
    if distance
      Geokit::Bounds.from_point_and_radius(origin,distance,:units=>units)
    else
      nil
    end
  end

  def distance_sql(origin, units=default_units, formula=default_formula)
    case formula
    when :sphere
      sql = sphere_distance_sql(origin, units)
    when :flat
      sql = flat_distance_sql(origin, units)
    end
    sql
  end

  def deg2rad(deg)
    deg / 180.0 * Math::PI
  end

  def sphere_distance_sql(origin, units)
    # "origin" can be a Geokit::LatLng (with :lat and :lng methods), e.g.
    # when using geo_scope or it can be an ActsAsMappable with customized
    # latitude and longitude methods, e.g. when using distance_sql.
    lat = deg2rad(get_lat(origin))
    lng = deg2rad(get_lng(origin))
    multiplier = units_sphere_multiplier(units)
    geokit_finder_adapter.sphere_distance_sql(lat, lng, multiplier) if geokit_finder_adapter
  end

  def get_lat(origin)
    origin.respond_to?(:lat) ? origin.lat \
                                 : origin.send(:"#{lat_column_name}")
  end

  def get_lng(origin)
    origin.respond_to?(:lng) ? origin.lng \
                                 : origin.send(:"#{lng_column_name}")
  end
end
