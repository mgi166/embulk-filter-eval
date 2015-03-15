module Embulk
  module Filter

    class EvalFilterPlugin < FilterPlugin
      Plugin.register_filter("eval", self)

      class NotFoundOutColumn < StandardError; end;
      VERSION = '0.1.0'

      def self.transaction(config, in_schema, &control)
        # configuration code:
        task = {
          "eval_columns" => config.param("eval_columns", :array, default: []),
          "out_columns" => config.param("out_columns", :array, default: [])
        }

        out_schema = out_schema(task['out_columns'], in_schema)

        yield(task, out_schema)
      end

      def self.out_schema(out_columns, in_schema)
        schema = out_columns.map.with_index do |name, i|
          sch = in_schema.find { |sch| sch.name == name }

          unless sch
            raise NotFoundOutSchema, "Not found output schema: `#{name}'"
          end

          Embulk::Column.new(index: i, name: sch.name, type: sch.type, format: sch.format)
        end
        schema.empty? ? in_schema : schema
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
