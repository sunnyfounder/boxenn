class MapperExtension < Boxenn::Repositories::RecordMapper
  def build(hash)
    result = batch_mapping(value: hash, mapper: map)
    result = custom_mapping(input: hash, result: result) if respond_to?(:custom_mapping, :include_private)
    result
  end

  def batch_mapping(value:, mapper:)
    case value
    when Array
      value.map do |item|
        mapping(hash: item, mapper: mapper)
      end
    when Hash
      mapping(hash: value, mapper: mapper)
    end
  end

  def mapping(hash:, mapper:)
    result = {}
    hash.each do |key, value|
      next if !mapper.key?(key)

      if mapper[key].is_a?(Array)
        result[mapper[key].first] = batch_mapping(value: value, mapper: mapper[key][1])
      else
        result[mapper[key]] = value.is_a?(Hash) ? value.compact : value
      end
    end
    result
  end
end
