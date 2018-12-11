# Instala as Gems
bundle check || bundle install
# Roda os jobs
bundle exec sidekiq -q edi_notfis
