require "csv"
require "gnuplot"
require "active_support"
require "active_support/core_ext"
require_relative "./Util"
require_relative "./PerceptronWithBias"

def main
	eta = 0.2
	# bias = rand(-3.0..3.0)
	# x_range = (-5.0..10)
	# y_range = (-5.0..10)
	bias = rand(-100.0..100)
	x_range = (-50.0..180)
	y_range = (-50.0..180)
	nand_path = "../nandData.csv"
	or_path = "../orData.csv"
	and_path = "../andData.csv"

	# 学習データを取得する
	input_data, input_ans = read_training_data("../BebebeData.csv")

	# 学習を開始(学習用データ全てに正答するまで学習し続ける)
	cnt = 0
	and_perceptron = PerceptronWithBias.new(eta, bias)
	plot_border_bias(and_perceptron, input_data, input_ans, "./AND/0", x_range, y_range)
	loop do
		and_perceptron.forward(input_data, input_ans, true)

		# デバッグ出力
		puts "cnt:#{cnt} w1:#{and_perceptron.weight[0].round(3)} w2:#{and_perceptron.weight[1].round(3)} bias:#{and_perceptron.bias.round(3)} flag:#{and_perceptron.is_all_corrected}"
		puts "output : #{and_perceptron.output.map {|outp| outp.round(3)}}"
		puts "actiated : #{and_perceptron.activated_output}"
		puts "teacher : #{input_ans}"
		puts ""

		# 学習データの散布図と，学習した境界線を表示
		#plot_border_bias(and_perceptron, input_data, input_ans, "./AND/" + String(cnt), x_range, y_range)

		# 正規化した出力がほしい(0.0~1.0)
		#tmp = and_perceptron.deep_dup
		tmp = and_perceptron
		tmp.bias /= tmp.weight.map {|www| www.abs}.sum / tmp.weight.size
		plot_border_bias(tmp, input_data, input_ans, "./AND/" + String(cnt += 1), x_range, y_range)

		# 学習回数5回ごとに学習係数を下げる
		and_perceptron.eta = cnt % 5 == 4 ? and_perceptron.eta * 0.95 : and_perceptron.eta
		# 確率で学習係数を跳ね上げる
		and_perceptron.eta = rand(0..30) == 0 ? eta : and_perceptron.eta

		break if and_perceptron.is_all_corrected
	end # loop
end


# コマンドラインから呼び出されたときのみ実行する
if __FILE__ == $0
	main
end
