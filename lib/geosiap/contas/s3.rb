class Geosiap::Contas::S3

  attr_reader :id, :url

  def initialize
    Aws.config.update({
      region: ENV['S3_REGION'],
      credentials: Aws::Credentials.new(ENV['S3_ACCESS_KEY_ID'], ENV['S3_SECRET_ACCESS_KEY'])
    })

    @bucket = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
  end

  def open(id)
    open_from_path("contas/store/#{id}")
  end

private

  attr_reader :bucket, :object

  def open_from_path(path)
    @object = bucket.object(path)
    @id = object.key.split('/').last
    @url = object.presigned_url(:get)
    self
  end

end
