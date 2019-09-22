"""
"""
import logging

__author__ = 'Viet Vu'

from flask import Flask

app = Flask(__name__)

# logger
gunicorn_logger = logging.getLogger('gunicorn.error')

fmt = '[%(asctime)s] [%(levelname)s] [%(name)s] - %(message)s'
fmter = logging.Formatter(fmt)

app.logger.handlers = gunicorn_logger.handlers
app.logger.setLevel(gunicorn_logger.level)
for handler in app.logger.handlers:
    handler.setFormatter(fmter)


@app.route('/')
def hello_world():
    app.logger.info('index info')
    app.logger.debug('index debug')
    app.logger.warn('index warn')
    app.logger.error('index error')
    return 'Hello World!'


if __name__ == '__main__':
    app.run()
