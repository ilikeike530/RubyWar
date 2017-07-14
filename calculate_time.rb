module TimeCalculation

	def TimeCalculation.seconds_to_words(total_seconds)

		seconds = total_seconds % 60
		minutes = (total_seconds / 60) % 60
		hours = total_seconds / (60 * 60)

		return "#{hours} hours, #{minutes} minutes, #{seconds} seconds" if hours > 1
		return "#{hours} hour, #{minutes} minutes, #{seconds} seconds" if hours > 0
		return "#{minutes} minutes, #{seconds} seconds"

	end
end


