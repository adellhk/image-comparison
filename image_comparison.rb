require 'sinatra'
# require 'byebug'
require 'chunky_png'
include ChunkyPNG::Color
include FileUtils::Verbose

get "/" do
	@images = Dir.glob('public/uploads/*.png')
	erb :index
end

post "/compare_images" do
	# compare_images(params[:first_image], params[:second_image])
	# ChunkPNG::Image.from_file('')
	compare_images(ChunkyPNG::Image.from_file("public/#{params[:first_image]}"), ChunkyPNG::Image.from_file("public/#{params[:second_image]}"))
	# message = {message:'hello'}
	# json :message
end

post '/upload' do
	tempfile = params[:file][:tempfile]
	filename = params[:file][:filename]
	cp(tempfile.path, "public/uploads/#{filename}")

	redirect '/'
end

def compare_images(first_image, second_image)
	unless (first_image.height == second_image.height && first_image.width == second_image.width)
		raise ArgumentError, "Images have different dimensions: #{first_image.height}px x #{first_image.width}px vs #{second_image.height}px x #{second_image.width}px."
	end

	differences = []
	first_image.height.times do |y|
		first_image.row(y).each_with_index do |pixel, x|
			differences << [x,y] if pixel != second_image[x,y]
		end
	end

	differences.each do |pixel|
		second_image[pixel[0], pixel[1]] = ChunkyPNG::Color.from_hex("#7CFC00")
	end
	second_image.save('public/uploads/output/output.png')
end

__END__

@@index
<link rel="stylesheet" href="style.css" type="text/css"/>
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script src="image_comparison.js"></script>
<div class="horizontally-centered vertically-centered">
	<form action='/upload' enctype="multipart/form-data" method='POST'>
	    <input name="file" type="file" />
	    <input type="submit" value="Upload" />
	</form>
	<div class="horizontal-scroll">
		<% @images.each_with_index do |image, index| %>
			<img src=<%=image[7..-1]%> id="image<%=index%>" class="uploaded-image">
		<% end %>
	</div>
	<form method="post" action="/compare_images">
		<button action="/compare_images" id="compareButton">compare</button>
	</form>
	<p>most recent comparison:</p>
<img src="/uploads/output/output.png">
</div>