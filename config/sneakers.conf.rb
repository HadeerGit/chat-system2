workers 2

before_fork do
  Sneakers::logger.info "I'm in a child process!"
end


after_fork do
  Sneakers::logger.info " I'm in a child process!"
end