# 学習データを読み込む
def read_training_data(path)
	# 学習用データを取得
	inputs = CSV.read(path)

	# 学習用データを入力と出力で分割
	input_data = Array.new(inputs.size).map {Array.new(2)}
	input_ans = Array.new(inputs.size)
	inputs.size.times do |i|
		input_data[i] = inputs[i].slice(0..1)
		input_ans[i] = inputs[i][-1]
	end

	# ファイル読み込みはString型なので各要素をNumeric型に変換
	#inputs = inputs.map{|in2| in2.map{|in3| in3.gsub(/[^\d]/, "").to_i}}
	input_data = input_data.map {|in2| in2.map {|in3| in3.gsub(/[^\d]/, "").to_i}}
	input_ans = input_ans.map(&:to_i)

	return input_data, input_ans
end


# 学習した結果を描画したい
def plot_border_bias(perceptron, input_data, input_ans, save_name, x_range, y_range)
	# グラフの描画範囲
	xrange = x_range.step(0.1).map{|xr| xr}
	yrange = y_range.step(0.1).map{|yr| yr}

	# 横幅，高さをそれぞれ抜き出し
	width = input_data.transpose[0]
	height = input_data.transpose[1]

	# 正解ラベルでデータを分ける
	width_positive = Array.new
	height_positive = Array.new
	width_negative = Array.new
	height_negative = Array.new
	width.size.times do |i|
		if input_ans[i] == 1
			width_positive.push(width[i])
			height_positive.push(height[i])
		else
			width_negative.push(width[i])
			height_negative.push(height[i])
		end
	end

	# 境界線データを作成
	border_x = xrange
	border_y = border_x.map {|xll| -perceptron.bias + xll *(perceptron.pre_weight[0] / perceptron.pre_weight[1] * (-1))}

	Gnuplot.open do |gp|
		Gnuplot::Plot.new(gp) do |plot|
			plot.terminal "png enhanced font 'ＭＳ 明朝' fontscale 3 size 1000, 1000 "
			plot.output save_name + ".png"
			plot.title "＿データの分布と境界線"
			plot.xlabel "Width"
			plot.ylabel "Height"
			plot.xrange "[" + String(xrange[0]) + ":" + String(xrange[-1]) + "]"
			plot.yrange "[" + String(yrange[0]) + ":" + String(yrange[-1]) + "]"
			plot.grid

			# 入力データの散布図(横長)
			plot.data << Gnuplot::DataSet.new([width_positive, height_positive]) do |ds|
				ds.with = "points pt 13 ps 3"
				ds.linecolor = 'rgb "red"'
				ds.notitle
			end # do

			# 入力データの散布図(縦長)
			plot.data << Gnuplot::DataSet.new([width_negative, height_negative]) do |ds|
				ds.with = "points pt 13 ps 3"
				ds.linecolor = 'rgb "green"'
				ds.notitle
			end # do

			# 重みの境界線
			plot.data << Gnuplot::DataSet.new([border_x, border_y]) do |ds|
				ds.with = "lines" # 点のみなら "points"
				ds.linewidth = 3
				ds.linecolor = 'rgb "blue"'
				ds.notitle
			end # do

			# X軸の描画
			xl = [xrange[0], xrange[-1]]
			plot.data << Gnuplot::DataSet.new([xl, Array.new(2, 0)]) do |ds|
				ds.with = "lines" # 点のみなら "points"
				ds.linewidth = 1
				ds.linecolor = 'rgb "black"'
				ds.notitle
			end # do

			# Y軸の描画
			yl = [yrange[0], yrange[-1]]
			plot.data << Gnuplot::DataSet.new([Array.new(2, 0), yl]) do |ds|
				ds.with = "lines" # 点のみなら "points"
				ds.linewidth = 1
				ds.linecolor = 'rgb "black"'
				ds.notitle
			end # do
		end # do
	end # do
end
