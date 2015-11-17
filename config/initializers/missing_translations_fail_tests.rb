# make missing translations fail your tests if use like this in specs:
# expect(page).to have_content t('dashboards.show.welcome', user: user)

if Rails.env.development? || Rails.env.test?
  I18n.exception_handler = lambda do |exception, locale, key, options|
    raise "missing translation: #{key}"
  end
end
