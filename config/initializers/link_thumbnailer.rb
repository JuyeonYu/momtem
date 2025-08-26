# config/initializers/link_thumbnailer.rb
LinkThumbnailer.configure do |config|
  # 필요한 속성만 파싱 (불필요한 네트워크/파싱 비용 절감)
  config.attributes = [:title, :description, :images]
  # 타임아웃/리다이렉트 제한
  config.http_timeout   = 8   # seconds
  config.redirect_limit = 3
  # SSL 에러가 많은 사이트가 있다면(개발용에서만) 완화 가능
  # config.verify_ssl = false
  # 가져올 이미지 수 제한 (첫 장만 쓰는 경우 1)
  config.image_limit = 1
end