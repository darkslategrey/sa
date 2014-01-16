
require 'logger'


module Axagenda
  module Logging
    def logger
      @logger ||= Axagenda::Logging.logger_for(self.class.name)
    end

    # Use a hash class-ivar to cache a unique Logger per class:
    @loggers = {}

    class << self
      def logger_for(classname)
        @loggers[classname] ||= configure_logger_for(classname)
      end

      def configure_logger_for(classname)
        logger = Logger.new('log/app.log', 'w')
        logger.progname = classname
        logger.level = Logger::Severity::DEBUG
        logger
      end
    end
  end
end
