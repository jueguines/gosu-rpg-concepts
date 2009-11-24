class GameWindow < Gosu::Window
  attr_reader :map
  attr_accessor :x, :y
  def initialize
    super(640, 480, false)
    self.caption = "Adventure"
    @monsters = []
    @map = Map.new(self, 'resources/map.txt')
    self.x = self.y = 0
    @player = Player.new(self, 32, 32)
    spawn_monsters
  end


  def update
    direction = :left if button_down? Gosu::Button::KbLeft
    direction = :right if button_down? Gosu::Button::KbRight
    direction = :up if button_down? Gosu::Button::KbUp
    direction = :down if button_down? Gosu::Button::KbDown
    @player.cast_spell if button_down? Gosu::Button::KbSpace
    @player.update(direction)
    self.x = [[@player.x - 300, 0].max, @map.width * 50 - 640].min
    self.y = [[@player.y - 220, 0].max, @map.height * 50 - 480].min
    @eye.update(@player)
  end

  def draw
    @map.draw x, y
    @player.draw x, y
    @player.spells.each {|s| s.draw(x,y) }
    @monsters.each do |monster|
      monster.draw(x, y)
      monster.spells.each {|s| s.draw(x,y) }
    end
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def spawn_monsters
    @monsters << @eye = Eye.new(self, 304, 16)
  end

end