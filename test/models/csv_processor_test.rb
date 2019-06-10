require 'test_helper'


class CsvProcessorTest < ActiveSupport::TestCase


  test "parsing" do
    @csv = CsvProcessor.new('./test/fixtures/files/csv1.csv')
    assert @csv.raw_data.count == 9
  end

  test 'error count'  do
    @csv = CsvProcessor.new('./test/fixtures/files/csv1.csv')
    assert @csv.error_rows.count == 2
  end

  test 'type_cards' do
    @csv = CsvProcessor.new('./test/fixtures/files/csv1.csv')
    assert Set.new(@csv.card_types) == Set.new(%w[ATR BLT COP])
  end

  test 'sales count' do
    @csv = CsvProcessor.new('./test/fixtures/files/csv1.csv')
    assert @csv.prepared_data['04.04.2019']['BLT'] == 69
    assert @csv.prepared_data['02.04.2019']['COP'] == 48
  end

  test 'other type cards' do
    @csv = CsvProcessor.new('./test/fixtures/files/csv2.csv')
    assert Set.new(@csv.card_types) == Set.new(%w[TEST1 TEST2 TEST3])

  end


end