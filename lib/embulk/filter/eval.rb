module Embulk
  module Filter

    class EvalFilterPlugin < FilterPlugin
      Plugin.register_filter("eval", self)

      def self.transaction(config, in_schema, &control)
        # configuration code:
        task = {
          "eval_columns" => config.param("eval_columns", :array, default: []),
          "out_schema" => config.param("out_schema", :array, default: [])
        }

        out_schema = config['out_schema'].map.with_index do |name, i|
          sch = in_schema.find { |sch| sch.name == name }
          Embulk::Column.new(index: i, name: sch.name, type: sch.type, format: sch.format)
        end

        out_schema = in_schema if out_schema.empty?

        yield(task, out_schema)
      end

      def init
        @table = task["eval_columns"]
      end

      def close
      end

      def add(page)
        page.each do |record|
          begin
            record = hash_record(record)

            result = {}

            record.each do |key, value|
              source = @table.find do |t|
                t.key?(key)
              end

              if source && source = source[key]
                result[key] = eval(source)
              else
                result[key] = value
              end
            end

            page_builder.add(result.values)
          rescue
          end
        end
      end

      def finish
        page_builder.finish
      end

      def hash_record(record)
        Hash[in_schema.names.zip(record)]
      end
    end

  end
end
