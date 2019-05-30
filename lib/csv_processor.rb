require 'csv'
class CsvProcessor

  def self.process(csv_file)
    data = []
    cards = []
    error_count = 0
    csv_text = File.read(csv_file)
    table = CSV.parse(csv_text, headers: true)
    table.by_row.each do |row_raw|
      row = {}
      row_raw.to_hash.each{|k, v| row[k.strip] = v.strip}
      if row["SalesCount"].nil?
        error_count += 1
        next
      end
      hash = {}
      hash['date'] = row["Date"]
      hash['card'] = row["CardType"].upcase
      hash['sales'] = row["SalesCount"].to_i
      cards.push(hash['card'])
      data.push(hash)
    end
    result = {}
    rs = []
    dates = data.group_by{|record| record['date'] }
    dates.each_with_index do |date, date_index|
      result[date.first] = {}
      card_types = date.last.group_by{|card| card['card'] }
      card_types.each do |card, records|
        sales_arr = records.map{|record| record['sales'] }
        row2 = {'date' => date.first, 'card' => card, 'sales' => sales_arr.inject(:+)/sales_arr.size}
        rs.push(row2)
        result[date.first][card] = row2['sales']
      end

    end
    final_result = {}
    result.each_key do |date|
      final_result[date] = {}
      cards.uniq.sort.each {|card| final_result[date][card] = result[date][card]?result[date][card]:0 }
    end
    {'rows'=>result,'cardTypes'=>cards.uniq, 'error_count' => error_count}
  end


end