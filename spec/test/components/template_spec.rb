require_relative '../support/utils'
include Utils

describe 'Template component', type: :feature, js: true do
  it 'Renders a simple and enhanced template tag on a page' do
    class ExamplePage < Matestack::Ui::Page
      def response
        # Simple template
        template id: 'foo', class: 'bar' do
          paragraph 'Template example 1'
        end
        # Enhanced template
        template id: 'foobar', class: 'bar' do
          example_content
        end
      end

      def example_content
        paragraph 'I am part of a partial'
      end
    end

    visit '/example'
    static_output = page.html
    # template tags are excluded from the output
    expected_static_output = <<~HTML 
      <p>Template example 1</p>
      <p>I am part of a partial</p>
    HTML
    expect(stripped(static_output)).to include(stripped(expected_static_output))
  end
end
