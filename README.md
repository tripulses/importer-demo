# README

* Importer Demo that runs on Rails 5.2.8.1 and Ruby 2.7.7
* Gemfile should be enough to make the application running. Some legacy gems were included as they were already present in the local of the machine where the application was developed.
* Data imported is present in `/lib/tasks` with the filename Data.txt
* Import of the data is handled in a rake task `etl:import_sample_data`. The rake task is already configured to run the sample data but an option to put in the filepath has been added.
* Unit testing has not been covered as there was an impediment in the setup and configuration to run Rspec.
* No additional frontend framework was included and the UI was built using Rails' built-in frontend framework.
* Sorting and Search for Affiliations and Locations is currently not supported.
