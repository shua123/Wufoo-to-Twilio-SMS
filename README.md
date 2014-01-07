# Wufoo to Twilio Text Message App

This app connects to a Wufoo form to gather phone number entries, then sends text messages through Twilio.

1) Clone repository
2) Change environment variables for Twilio and Wufoo API keys. 
3) Application start: "Foreman start"
4) Deploy to Heroku

On Heroku, a worker process is required to run. (heroku ps:scale worker=1)

Wufoo field numbers stored as environmental variables.

