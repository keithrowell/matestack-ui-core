module Matestack
  module Ui
    module VueJs
      module Components
        module Collection
          class Next < Matestack::Ui::Component
            
            def response
              a options.merge('@click': 'next()') do
                yield
              end
            end
            
          end
        end
      end
    end
  end
end
