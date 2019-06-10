class HomeController < ApplicationController
  def index
  end

  def upload
    uploaded_io = params[:csv]
    mode = 'wb'
    if params['submit'] == 'Add to existing'
      mode = 'ab'
    end
    File.open(Rails.root.join('public', 'uploads', 'csv.csv'), mode) do |file|
      file.write(uploaded_io.read)
    end
    @data = CsvProcessor.new(Rails.root.join('public', 'uploads', 'csv.csv'))

  end
end
