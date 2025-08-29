package com.github.jamesnetherton.zulip.client.api.channel.request;

interface ChannelRequestConstants {
    String CHANNELS = "channels";
    String CREATE_CHANNELS = CHANNELS + "/create";
    String CHANNEL_FOLDERS = "channel_folders";
    String CREATE_CHANNEL_FOLDERS = CHANNEL_FOLDERS + "/create";
    String CHANNEL_FOLDERS_WITH_ID = CHANNEL_FOLDERS + "/%d";
}
