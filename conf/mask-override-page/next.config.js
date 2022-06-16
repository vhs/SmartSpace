/** @type {import('next').NextConfig} */

const nextConfig = {
  serverRuntimeConfig: {
    mqttUri: 'ws://mosquitto-trust:9001/mqtt',
    mqttTopic: '/status/space/mask-override',
    mqttInterval: 15,
    mqttRunningValue: 'on',
    mqttStoppedValue: 'off',
    ...{}
  },
  publicRuntimeConfig: {
    title: 'Mask Status Control Panel',
    ...{}
  },
  reactStrictMode: true,
  experimental: {
    outputStandalone: true
  }
}

module.exports = nextConfig
