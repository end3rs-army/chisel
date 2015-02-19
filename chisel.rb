class Chisel

	attr_reader :string, :parsed, :sentance, :line

	def initialize(doc)
		@string = doc
		@parsed = []
		@line = {}
		@end_of_file_flag = false
		@number_list = false
	end

	def parse 
		@sentance = @string.split("\n")
		#@parsed = @string.scan (/\S+|\n+|\t+| |/)
	end 

	def write

		@sentance.each_with_index do |x,index|

			@parsed = x.scan(/\S+|\n+|\t+| |/)

			if @parsed[0] == "#"
				heading_one(x,index)
			elsif @parsed[0] == "##"
				heading_two(x,index)
			elsif x == ""
				@line[index] = ["\n"]
			else
				paragraph(x,index)
			end
		end
	end

	def heading_one(sentance,key)
		@line[key] = ["<h1>"]
		(2..@parsed.size-1).each do |x|
			@line[key] += [@parsed[x]]
		end
		if @line[key].last == ""
			@line[key].delete_at(@line[key].size-1)
		end
		@line[key] += ["</h1>"]

		#print @line[key]
	end

	def heading_two(sentance,key)
		@line[key] = ["<h2>"]
		(2..@parsed.size-1).each do |x|
			@line[key] += [@parsed[x]]
		end
		if @line[key].last == ""
			@line[key].delete_at(@line[key].size-1)
		end
		@line[key] += ["</h2>"]

		#print @line[key]
	end

	def paragraph(sentance,key)
		@line[key] = ["para"]
		(0..@parsed.size-1).each do |x|
			
			number_analyzer(@parsed[x])
			
			if @number_list == true
				@parsed[x] = "<li>"
			elsif @parsed[x] == "*" || @parsed[x] == "1." || @parsed[x] == "2." || @parsed[x] == "3."
				@parsed[x] = "<li>"
			end
			sentance_analyzer(@parsed[x])
			@line[key] += [@parsed[x]]

			@number_list = false
		end
	end

	def sentance_analyzer(words)
		words.sub!("**","<strong>")
		words.sub!("*","<em>")
	end

	def number_analyzer(words)
		(0..100).each do |x|
			check = x.to_s + "."
			if words == check
				@number_list = true
			end
		end
	end

	def print
		(0..@sentance.size-1).each do |x|
			if x > 0 && @line[x][0] == "para" && @line[x-1][0] != "para"
				line[x-1] += ["<p>"]
				@end_of_file_flag = true
			end
			if x != @sentance.size-1 && @line[x][0] == "para" && @line[x+1][0] != "para"
				line[x+1] = ["</p>"]
				@end_of_file_flag = false
			end
			if @line[x].include?("<li>")
				@line[x]<< " </li>"
			end
		end

		(0..@sentance.size-1).each do |x|
			if @line[x][0] == "para"
			  	@line[x].delete_at(0)
			 	@line[x].insert(0,"\t")
			end
			if @line[x][0] == "</p>" && @line[x][1] == "<p>"
				puts @line[x]
			else
				puts @line[x].join
			end
		end
		
		if @end_of_file_flag == true
			puts "</p>"
		end
	end

end

chive = Chisel.new('# My Life in Desserts

## Chapter 1: The Beginning

"You just *have* to try the cheesecake," he said. "Ever since it appeared in
**Food & Wine** this place has been packed every night."

My favorite cuisines are:

1. Sushi
2. Barbeque
3. Mexican

This is because

* They are awesome
* I like hot stuff

## This is a NEW HEADING
')

chive.parse
chive.write
chive.print



