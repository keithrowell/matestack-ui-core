class Demo::Pages::Collection < ApplicationPage
  include Matestack::Ui::VueJs::Components::Collection::Helper

  def prepare
    @collection_id = 'dummy-collection'

    base_query = DummyModel.all

    filter = get_collection_filter(@collection_id)
    order = get_collection_order(@collection_id)

    filtered_query = base_query
    filtered_query = filtered_query.where(id: filter[:bar]) if filter[:bar].present?
    filtered_query = filtered_query.where('title LIKE ?', "%#{filter[:title]}%") if filter[:title].present?
    ordered_query = filtered_query
    ordered_query = filtered_query.order(order) if order.present?

    @collection = set_collection(
      id: @collection_id,
      data: ordered_query,
      init_limit: 20,
      base_count: base_query.count,
      filtered_count: filtered_query.count
    )
  end

  def response
    order_partial
    filter_partial
    async id: 'dummy-collection-async', rerender_on: "#{@collection_id}-update" do
      collection_content @collection.config do
        @collection.paginated_data.each do |dummy|
          paragraph dummy.title
        end
        pagination
      end
    end
  end

  def order_partial
    collection_order @collection.config do
      plain "sort by:"
      collection_order_toggle key: :title do
        button do
          plain "Title"
          collection_order_toggle_indicator key: :title, asc: '&#8593;', desc: '&#8595;', default: ""
        end
      end
    end
  end

  def filter_partial
    collection_filter @collection.config do
      form_input key: :title, type: :text, label: 'Test', class: "form-control"
      form_checkbox key: :xyz, label: 'Check'
      form_checkbox key: :bar, options: [1,2,3]
      form_select key: :wtf, options: [1,2,3]
      button 'Submit', type: "submit"
      collection_filter_reset do
        button 'Reset'
      end
    end
  end

  def pagination
    plain "showing #{@collection.from}"
    plain "to #{@collection.to}"
    plain "of #{@collection.base_count}"
    collection_content_previous do
      button "previous"
    end
    @collection.pages.each do |page|
      collection_content_page_link page: page do
        button page
      end
    end
    collection_content_next do
      button "next"
    end
  end

end
