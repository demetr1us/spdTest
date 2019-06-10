require 'csv'
class CsvProcessor

  @raw_data = []
  @chart_labels = []
  @chart_data = []
  @chart_dates = []
  @prepared_data = []
  @error_rows = []
  @card_types = []
  @formatted_data = []
  attr_accessor :raw_data, :chart_labels, :chart_data, :prepared_data,
                :error_rows, :card_types, :formatted_data, :chart_dates

  def initialize(csv)
    @error_rows=[]
    @chart_dates = []
    csv = self.process(csv)
    csv.chart
    csv
  end


  def process(csv_file)
    data = []
    cards = []
    csv_text = File.read(csv_file)
    table = CSV.parse(csv_text, headers: true)
    table.by_row.each_with_index  do |row_raw, index|
      row = {}
      begin
      row_raw.to_hash.each {|k, v| row[k.strip] = v.strip}
      if row["SalesCount"].nil? || (row["SalesCount"] =~ /\d+/) != 0 || row.keys.count != 3
        throw 'Invalid row'
      end
      rescue StandardError => e
        @error_rows.push({row: row_raw.to_s, idx: (index+1)})
        next

      end
      hash = {}
      hash['date'] = row["Date"]
      hash['card'] = row["CardType"].upcase
      hash['sales'] = row["SalesCount"].to_i
      cards.push(hash['card'])
      data.push(hash)
    end
    @raw_data = data
    @card_types = cards.uniq
    prepareData(data)
    self
  end

  def prepareData(data)
    result = {}
    rs = []
    dates = data.group_by {|record| record['date']}
    dates.each_with_index do |date, date_index|
      result[date.first] = {}
      card_types = date.last.group_by {|card| card['card']}
      card_types.each do |card, records|
        sales_arr = records.map {|record| record['sales']}
        row2 = {'date' => date.first, 'card' => card, 'sales' => sales_arr.inject(:+)/sales_arr.size}
        rs.push(row2)
        result[date.first][card] = row2['sales']
        @chart_dates.push(date.first)
      end
      @prepared_data = result
    end
  end

  def chart
    labels = []
    data = []
    @prepared_data.values.each do |row|
      labels.push(row.keys)
      data.push(row.values)
    end
    @chart_labels = labels.flatten
    @chart_data = data.flatten
  end


end