# Crystal: Ping


# Contains a simple ping command.
module Bot::Ping
  extend Discordrb::Commands::CommandContainer
  
  command :ping,
          description: 'Pings the bot and displays the response time.',
          usage: '+ping' do |event|
    before = Time.now
    msg = event.respond '**PongChamp**'
    after = Time.now
    msg.edit <<~EDIT.strip
      **PongChamp**
      Time taken: #{((after - before) * 1000).round}ms
    EDIT
  end
end