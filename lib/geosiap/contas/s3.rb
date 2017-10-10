class Geosiap::Contas::S3

  attr_reader :id, :url

  def initialize
    s3 = AWS::S3.new({
      access_key_id: ENV['S3_ACCESS_KEY_ID'],
      secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
    })

    @bucket = s3.buckets[ENV['S3_BUCKET']]
  end

  def open(id)
    open_from_path("contas/store/#{id}")
  end

private

  attr_reader :bucket, :object

  def open_from_path(path)
    @object = bucket.objects[path]
    @id = object.key.split('/').last
    @url = object.url_for(:get).to_s
    self
  end

end
