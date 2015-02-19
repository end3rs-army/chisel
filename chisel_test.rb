require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './chisel'


class ChiselTest < Minitest::Test 

	def test_it_exists
		assert Chisel 
	end

	def test_it_reads_a_string
		chive = Chisel.new("string")
		assert_equal "string",chive.string 
	end

	def test_it_splits_a_string
		chive = Chisel.new("String on
							on two lines")
		chive.parse 
		assert_equal ["String", " ", "on", "\n", "\t\t\t\t\t\t\t", "on", " ", "two", " ", "lines"],chive.parsed 
	end

	
	# #Can't get test to check for terminal output
	# def test_it_pints_heading_1
	# 	chive = Chisel.new("# Heading One")
	# 	chive.parse
	# 	chive.write
	# 	assert_output "<h1>Heading One"
	# end

	
end

