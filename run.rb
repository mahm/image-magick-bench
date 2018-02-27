require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'fileutils'

SAMPLES = {
  '625' => '625x417.jpg',
  '1250' => '1250x834.jpg',
  '2500' => '2500x1668.jpg',
  '5000' => '5000x3336.jpg'
}
SAMPLES.each do |k, v|
  define_method :"resize_#{k}_to" do |resize_width|
    image = MiniMagick::Image.open("./images/#{v}")
    image.resize "#{resize_width}"
    image.write "./output/#{image.object_id}.jpg"
  end
end

puts '大きな画像から、そこそこ大きい画像（幅2000px）に縮小するときのパフォーマンス差'
Benchmark.ips do |x|
  x.report( "5000 -> 2000" ) { resize_5000_to(2000) }
  x.report( "2500 -> 2000" ) { resize_2500_to(2000) }
  x.compare!
end

puts '大きな画像から、中ぐらいの画像（幅1000px）に縮小するときのパフォーマンス差'
Benchmark.ips do |x|
  x.report( "5000 -> 1000" ) { resize_5000_to(1000) }
  x.report( "2500 -> 1000" ) { resize_2500_to(1000) }
  x.report( "1250 -> 1000" ) { resize_1250_to(1000) }
  x.compare!
end

puts '大きな画像から、小さい画像（幅400px）に縮小するときのパフォーマンス差'
Benchmark.ips do |x|
  x.report( "5000 -> 400" ) { resize_5000_to(400) }
  x.report( "2500 -> 400" ) { resize_2500_to(400) }
  x.report( "1250 -> 400" ) { resize_1250_to(400) }
  x.report( " 625 -> 400" ) { resize_625_to(400) }
  x.compare!
end

FileUtils.rm_r(Dir.glob('./output/*'), secure: true)
