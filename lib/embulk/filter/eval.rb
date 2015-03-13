module Embulk
  module Filter

    class EvalFilterPlugin < FilterPlugin
      Plugin.register_filter("eval", self)

      def self.transaction(config, in_schema, &control)
        # configuration code:
        task = {
          "eval_columns" => config.param("eval_columns", :array, default: [])
        }

        yield(task, in_schema)
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
