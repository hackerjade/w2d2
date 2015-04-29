class Board
  PIECES = [Rook, Knight,Bishop,King,Queen,Bishop,Knight,Rook]


  def initialize(set_up = true)
    @grid = Array.new(8) {Array.new(8) }
    set_piece_positions if set_up
  end

  def on_board?(pos)
    byebug if pos.nil?
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end

  def in_check?(color)
    king_piece = king(color)
    other_pieces = color == :white ? pieces(:black) : pieces(:white)

    other_pieces.each do |other_piece|
      next if other_piece.moves.empty?
      return true if other_piece.moves.include?(king_piece.pos)
    end

    return false
  end

  def checkmate?(color)
    in_check?(color) && pieces(color).all?{|piece| valid_moves(self[piece].moves).nil?}
  end

  def pieces(color)
    pieces = @grid.flatten.compact
    pieces.select { |piece| piece.color == color}
  end

  def king(color)
    pieces(color).find { |piece| piece.is_a?(King)}
  end

  def move(start_pos, end_pos)
    raise "Invalid move." if self[start_pos] == nil
    total_moves = self[start_pos].moves
    valid_moves = self[start_pos].valid_moves(total_moves)

    raise "Invalid move." unless valid_moves.include?(end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    self[start_row,start_col],self[end_row,end_col] = nil, self[start_pos]

    self
  end

  def move!(start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    self[start_row,start_col],self[end_row,end_col] = nil, self[start_pos]

    self
  end

  def set_piece_positions
    (0..7).each do |row|
      next if row.between?(2,5)
      (0..7).each do |col|
        if row == 0
          self[row,col] = PIECES[col].new(self,[row,col],:white,false)
        elsif row == 7
          self[row,col] = PIECES.reverse[col].new(self,[row,col],:black,false)
        # elsif row == 1
        #   self[row,col] = Pawn.new(self,[row,col],:white,false)
        # else
        #   self[row,col] = Pawn.new(self,[row,col],:black,false)
        end
      end
    end
  end

  def render
    (0..7).map do |row|
      (0..7).map do |col|
        if row % 2 == 0 && col % 2 == 0 || row % 2 != 0 && col % 2 != 0
          color = :light_yellow
        else
          color = :light_green
        end
        if @grid[row][col] == nil
          "  ".colorize(:background => color)
        else
          "#{@grid[row][col].display} ".colorize(:background => color)
        end
      end.join('')
    end.join("\n")
  end

  def deep_dup
    new_board = Board.new(false)

    (0..7).each do |row|
      (0..7).each do |col|
        next if @grid[row][col] == nil
        new_board[row, col] = @grid[row][col].dup(new_board)
      end
    end

    new_board
  end


  def occupied?(pos)
    # byebug
    !self[pos].nil?
  end

  def [](pos)
    row,col = pos
    byebug if @grid[row].nil?
    @grid[row][col]
  end

  def []=(row,col,value)
    # row,col = pos
    @grid[row][col] = value
  end
end




#   + occupied?(pos)
#   + piece_at(pos)
#   + checkmate?
#   + check?
#   + `#deep_dup`
#
