class App < Matestack::Ui::App

  def response
    yield
  end

end
