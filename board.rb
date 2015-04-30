class Board
  attr_accessor :cursor

  PIECES = [ Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook ]

  def initialize(set_up = true)
    @grid = Array.new(8) {Array.new(8) }
    @cursor = [0,4]
    set_piece_positions if set_up
  end

  def move_cursor(direction)
    dx, dy = direction
    new_position = [@cursor[0] + dx, @cursor[1] + dy]
    @cursor = new_position if on_board?(new_position)
  end

  def on_board?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end

  def in_check?(color)
    king_piece = king(color)
    other_pieces = pieces(color)
    other_pieces = color == :white ? pieces(:black) : pieces(:white)

    other_pieces.each do |other_piece|
      next if other_piece.moves.empty?
      return true if other_piece.moves.include?(king_piece.pos)
    end

    return false
  end

  def checkmate?(color)
    in_check?(color) && pieces(color).all? do |piece|
      piece.valid_moves(piece.moves).empty?
    end
  end

  def pieces(color)
    pieces = @grid.flatten.compact
    pieces.select { |piece| piece.color == color}
  end

  def king(color)
    pieces(color).find { |piece| piece.is_a?(King)}
  end

  def move(start_pos, end_pos)
    raise "No position specificed." if start_pos == nil || end_pos == nil
    raise "No piece is there." if self[start_pos] == nil
    total_moves = self[start_pos].moves
    valids = self[start_pos].valid_moves(total_moves)

    raise "Invalid move." unless valids.include?(end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    start_piece = self[start_pos]
    start_piece.pos = end_pos
    start_piece.moved = true
    self[end_row, end_col] = start_piece
    self[start_row,start_col] = nil


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
          self[row,col] = PIECES[col].new(self,[row,col],:black,false)
        # elsif row == 1
        #   self[row,col] = Pawn.new(self,[row,col],:white,false)
        # else
        #   self[row,col] = Pawn.new(self,[row,col],:black,false)
        end
      end
    end
  end

  def render(p_color)
    (0..7).map do |row|
      (0..7).map do |col|
        if [row, col] == @cursor
          color = p_color
        elsif row % 2 == 0 && col % 2 == 0 || row % 2 != 0 && col % 2 != 0
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
    !self[pos].nil?
  end

  def [](pos)
    row,col = pos
    byebug if pos.nil?
    @grid[row][col]
  end

  def []=(row,col,value)
    # row,col = pos
    @grid[row][col] = value
  end
end
