module Rake
  class Pipeline
    module Layout
      class Filter < Rake::Pipeline::Filter
        attr_reader :options, :path, :locale, :context

        def initialize(options={}, context = nil, &block)
          @options = options
          @path = options.delete(:path)
          @context = context || Object.new
          super(&block)
        end

        def generate_output(inputs, output)
          inputs.each do |input|
            template = Tilt.new(path, 1, options)
            out = template.render(context) { input.read }
            output.write(out)
          end
        end

        private

        # hack - add layout file to rake tasks dependencies
        def create_file_task(output, deps = [], &block)
          deps << path
          super(output, deps, &block)
        end
      end

      module Helpers
        def layout(*args, &block)
          filter(Rake::Pipeline::Layout::Filter, *args, &block)
        end
      end
    end
  end
end

Rake::Pipeline::DSL::PipelineDSL.send(:include, Rake::Pipeline::Layout::Helpers)
