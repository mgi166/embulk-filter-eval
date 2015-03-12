module Embulk
  module Filter

    class EvalFilterPlugin < FilterPlugin
      Plugin.register_filter("eval", self)

      def self.transaction(config, in_schema, &control)
        # configuration code:
        task = {
          "eval_columns" => config.param("eval_columns", :array)
        }

        yield(task, out_columns)
      end

      def init
        # initialization code:
        @property1 = task["property1"]
        @property2 = task["property2"]
      end

      def close
      end

      def add(page)
        # filtering code:
        page.each do |record|
          page_builder.add(record)
        end
      end

      def finish
        page_builder.finish
      end
    end

  end
end
