require_relative "../../../../support/utils"
require_relative "../../../../support/test_controller"
require_relative "../support/form_test_controller"
require_relative "../support/model_form_test_controller"
include Utils

describe "Form Component", type: :feature, js: true do


  before :all do
    Rails.application.routes.append do
      scope "form_custom_textarea_spec" do
        post '/input_success_form_test', to: 'form_test#success_submit', as: 'custom_textarea_success_form_test'
        post '/input_failure_form_test/:id', to: 'form_test#failure_submit', as: 'custom_textarea_failure_form_test'
        post '/input_model_form_test', to: 'model_form_test#model_submit', as: 'custom_textarea_model_form_test'
      end
    end
    Rails.application.reload_routes!
  end

  before :each do
    allow_any_instance_of(FormTestController).to receive(:expect_params)

    class Components::CustomFormTextareaTest < Matestack::Ui::VueJs::Components::Form::Textarea

      vue_name "custom-form-textarea-test"

      def response
        div class: "custom-input-markup" do
          label text: "my form textarea"
          textarea textarea_attributes
          button "change value", type: :button, "@click": "changeValueViaJs(42)"
          render_errors
        end
      end

      register_self_as(:custom_form_textarea_test)
    end
  end

  describe "custom input components" do

    it "can be used for individual input markup rendering and data processing via custom JS/3rd party JS" do

      class ExamplePage < Matestack::Ui::Page
        def response
          matestack_form form_config do
            custom_form_textarea_test key: :bar, id: "bar"
            button 'Submit me!'
          end
        end

        def form_config
          return {
            for: :my_object,
            method: :post,
            path: custom_textarea_success_form_test_path
          }
        end
      end

      visit '/example'

      expect(page).to have_xpath('//div[@class="custom-input-markup"]/textarea[@id="bar" and @class="js-added-class"]')

      click_button "change value"

      expect_any_instance_of(FormTestController).to receive(:expect_params)
        .with(hash_including(my_object: { bar: 42 }))

      click_button "Submit me!"

    end

    it "can be used within core form along other core inputs" do

      class ExamplePage < Matestack::Ui::Page
        def response
          matestack_form form_config do
            form_textarea key: :foo, id: "foo"
            custom_form_textarea_test key: :bar, id: "bar"
            button 'Submit me!'
          end
          toggle show_on: "form_submitted", id: 'async-form' do
            plain "form submitted!"
          end
        end

        def form_config
          return {
            for: :my_object,
            method: :post,
            path: custom_textarea_success_form_test_path,
            success: { emit: "form_submitted" }
          }
        end
      end

      visit '/example'

      fill_in "foo", with: "foo"
      fill_in "bar", with: "bar"
      expect_any_instance_of(FormTestController).to receive(:expect_params)
        .with(hash_including(my_object: { bar: "bar", foo: "foo" }))

      click_button "Submit me!"
      expect(page).to have_content("form submitted!")
    end

    it "can be initialized with value" do

      class ExamplePage < Matestack::Ui::Page
        def response
          matestack_form form_config do
            custom_form_textarea_test id: "text-input", key: :text_input, init: "some value"
            button "Submit me!"
          end
        end

        def form_config
          {
            for: :my_object,
            method: :post,
            path: custom_textarea_success_form_test_path
          }
        end
      end

      visit "/example"
      expect(page).to have_field("text-input", with: "some value")
    end

    it "can extend initialization via custom JS (trigger 3rd party libraries for example)" do

      class ExamplePage < Matestack::Ui::Page
        def response
          matestack_form form_config do
            custom_form_textarea_test id: "text-input", key: :text_input, init: "change me via JS"
            button "Submit me!"
          end
        end

        def form_config
          {
            for: :my_object,
            method: :post,
            path: custom_textarea_success_form_test_path
          }
        end
      end

      visit "/example"
      expect(page).to have_field("text-input", with: "done")
    end

    it "can be prefilled with a placeholder" do

      class ExamplePage < Matestack::Ui::Page
        def response
            matestack_form form_config do
              form_textarea key: :foo, id: "foo", placeholder: "some placeholder"
              custom_form_textarea_test id: "text-input", key: :text_input, placeholder: "some placeholder"
              button "Submit me!"
            end
        end

        def form_config
          {
            for: :my_object,
            method: :post,
            path: custom_textarea_success_form_test_path,
          }
        end
      end

      visit "/example"
      expect(page).to have_field("text-input", with: "")
      expect(page).to have_field("text-input", placeholder: "some placeholder")
    end

    it "can display server errors async" do
      class ExamplePage < Matestack::Ui::Page
        def response
          matestack_form form_config do
            custom_form_textarea_test id: "text-input", key: :foo
            button "Submit me!"
          end
        end

        def form_config
          {
            for: :my_object,
            method: :post,
            path: custom_textarea_failure_form_test_path(id: 42)
          }
        end
      end

      visit "/example"
      fill_in "text-input", with: "text"
      click_button "Submit me!"
      expect(page).to have_xpath('//div[@class="errors"]/div[@class="error" and contains(.,"seems to be invalid")]')
    end

    it "can be mapped to an Active Record Model" do
      Object.send(:remove_const, :TestModel)

      class TestModel < ApplicationRecord
        validates :description, presence:true
      end

      class ExamplePage < Matestack::Ui::Page
        def prepare
          @test_model = TestModel.new
          @test_model.title = "Title"
        end

        def response
          matestack_form form_config do
            custom_form_textarea_test id: "title", key: :title
            custom_form_textarea_test id: "description", key: :description
            button "Submit me!"
          end
        end

        def form_config
          return {
            for: @test_model,
            method: :post,
            path: custom_textarea_model_form_test_path
          }
        end
      end

      visit "/example"
      expect(page).to have_field("title", with: "Title")
      click_button "Submit me!"
      expect(page).to have_field("title", with: "Title")
      expect(page).to have_xpath('//div[@class="errors"]/div[@class="error" and contains(.,"can\'t be blank")]')

      value = "#{DateTime.now}"
      fill_in "description", with: value
      page.find("body").click #defocus
      click_button "Submit me!"
      expect(page).to have_field("title", with: "Title")
      expect(page).to have_field("description", with: "")
      expect(page).not_to have_xpath('//div[@class="errors"]/div[@class="error" and contains(.,"can\'t be blank")]')
      expect(TestModel.last.description).to eq(value)
    end

  end

end
