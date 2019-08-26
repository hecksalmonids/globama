# Crystal: Source


# Contains a command that links the bot's repository.
module Bot::Source
  extend Discordrb::Commands::CommandContainer
  
  command :source,
          description: "Links Globama's GitHub repository.",
          usage: '+source' do |event|
    event.send_embed do |embed|
      embed.description = <<~DESC.strip
        The source code can be found in [this](https://github.com/hecksalmonids/globama) repository.
      DESC
      embed.footer = {text: 'All of you are amazing; thanks so much for being my friends 💚 - Katie'}
      embed.color = 0xFFD700
    end
  end
end