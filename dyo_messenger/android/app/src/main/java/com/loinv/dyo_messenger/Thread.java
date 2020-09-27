package com.loinv.dyo_messenger;

public class Thread {
    private String id;
    private String recipientIds;
    private String isRead;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRecipientIds() {
        return recipientIds;
    }

    public void setRecipientIds(String recipientIds) {
        this.recipientIds = recipientIds;
    }

    public String getIsRead() {
        return isRead;
    }

    public void setIsRead(String isRead) {
        this.isRead = isRead;
    }
}
