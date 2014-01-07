# Wufoo to Twilio Text Message App

This app connects to a Wufoo form to gather phone number entries, then sends text messages through Twilio. 

Uses Rails, Postgres, Wufoo API, Twilio API

* Clone repository
* Change environment variables for Twilio and Wufoo API keys. 
* Application start: "Foreman start"
* Deploy to Heroku

On Heroku, a worker process is required to run. (heroku ps:scale worker=1)

Wufoo field numbers stored as environmental variables.

