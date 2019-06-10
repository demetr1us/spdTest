require 'test_helper'


class CsvProcessorTest < ActiveSupport::TestCase

  test "parsing" do
    csv = CsvProcessor.new('./test/fixtures/files/csv1.csv')
    assert csv.raw_data.count == 9
    assert csv.error_rows.count == 2

  end
end