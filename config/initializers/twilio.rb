#path = File.join(Rails.root, "config/twilio.yml")
TWILIO_CONFIG = {'sid' => ENV['TWILIO_SID'], 'from' => ENV['TWILIO_FROM'], 'token' => ENV['TWILIO_TOKEN']} 