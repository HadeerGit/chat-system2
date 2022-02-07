Sneakers.configure(connection: Bunny.new(hostname: "rabbitmq:5672"), log: "log/sneakers.log", durable: true, daemonize: true, prefetch: 1, threads: 1)
Sneakers.logger.level = Logger::ERROR