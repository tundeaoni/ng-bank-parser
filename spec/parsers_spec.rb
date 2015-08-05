require 'spec_helper'

describe "Parsers" do
	subject { $Parsers }

	it { is_expected.to be_a_kind_of(Array) }
	it { is_expected.not_to be_empty }
end


describe "Every Parser" do
	subject { $Parsers }

	it "is unique" do
		expect(subject.length).to equal(subject.uniq.length)
	end
	it "has valid keys" do
		subject.each do |parser|
			expect(parser).to match({
				:key => an_instance_of(String),
				:name => an_instance_of(String),
				:format => an_instance_of(String),
				:valid => an_instance_of(String),
				:invalid => an_instance_of(String)
        	})
		end
	end
	it "has parser file" do
		subject.each do |parser|
			filename = parser[:key] + "-" + parser[:format] + "-parser.rb"
			path = "lib/ng-bank-parser/parsers/" + filename
			
			expect(File).to exist(path), "Didnt find #{filename} in the parsers folder"
			expect(File).to exist(path), "Didnt find #{filename} in the parsers folder"
		end
	end
end

$Parsers.each do |parser|
	describe parser[:key].capitalize + " " + parser[:format] + " " +  "parser" do
		class_name= parser[:key].capitalize + parser[:format].capitalize;
		class_object = NgBankParser.const_get(class_name)

		context "with valid statement" do
			valid_response = class_object.parse()

			it "parses statement correctly" do
				expect(valid_response).to match({
					:bank_name => an_instance_of(String),
					:account_number => an_instance_of(String),
					:account_name => an_instance_of(String),
					:from_date => an_instance_of(Date),
					:to_date => an_instance_of(Date),
					:transactions => an_instance_of(Array)
	        	})
			end

			it "returns valid transactions" do
	        	valid_response[:transactions].each do |row|
	        		expect(row).to match({
						:date => an_instance_of(Date),
						:type => a_string_matching(/^(credit|debit)$/),
						# :type => an_instance_of(String),
						:amount => an_instance_of(Fixnum),
						:ref => an_instance_of(String),
						:remarks => an_instance_of(String)
		        	})
	        	end
			end
		end
	end
end