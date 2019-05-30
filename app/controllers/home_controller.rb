class HomeController < ApplicationController
  require_relative '../../lib/csv_processor.rb'
  def index
  end
  def upload
    uploaded_io = params[:csv]
    File.open(Rails.root.join('public', 'uploads', 'csv.csv'), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    @data =  CsvProcessor.process(Rails.root.join('public', 'uploads', 'csv.csv'))
    @labels = []
    @data['rows'].keys.each {|date| @labels  = @labels + [date]*@data['rows'][date].size }

    @data['rows'].values

  end
end
