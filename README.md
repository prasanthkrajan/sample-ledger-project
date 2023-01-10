# Sample Ledger Project

### Development Setup

1. Ensure you run `bundle install`, and `rake db:reset`, prior to `rails s`

### Background

#### Request 1

* first version of the application
* retrieves the data from API, and performs caching
* displays developer-friendly error message, if the endpoint is down
* API endpoint can be easily changed from `application.yml`

#### Request 2

* uses `LedgerDataCalculator` to calculate the total amount, with `USD` as the preferred currency
* can switch currency by passing in a currency code as an argument in `LedgerDataCalculator`
* currency conversion is done using `eu_central_bank` gem

#### Request 3

* uses `LedgerDataCsvHandler` to generate data related to csv generation
* generates csv with formatted amount and raw amount for accounting purpose


#### Request 4

* allows user to enter multiple ledger entries from a form and create a new ledger
* all fields in ledger entries are made mandatory
* potential improvement: to allow users to use the downloaded csv as a template and upload with prefilled data to create new ledger (alternative to filling in forms with multiple entries)