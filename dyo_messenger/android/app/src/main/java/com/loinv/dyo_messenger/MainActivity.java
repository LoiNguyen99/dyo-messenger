package com.loinv.dyo_messenger;


import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.provider.MediaStore;
import android.provider.Telephony;
import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;
import android.util.Base64;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringJoiner;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.loinv.flutter/sms";

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    protected void onResume() {
        super.onResume();
        final String myPackageName = getPackageName();
        if (!Telephony.Sms.getDefaultSmsPackage(this).equals(myPackageName)) {
            Intent intent =
                    new Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT);
            intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME,
                    myPackageName);
            startActivity(intent);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    Gson gson = new Gson();
                    if (call.method.equals("getAllSms")) {
                        List<Sms> smsList = getAllMessage();
                        String jsonList = gson.toJson(smsList);
                        result.success(jsonList);
                    } else if (call.method.equals("getContactByPhone")) {
                        String phoneNumber = call.argument("phoneNo");
                        Contact contact = getContactByPhone(phoneNumber);
                        result.success(gson.toJson(contact));
                    }else if (call.method.equals("readAllSms")) {
                        String phoneNumber = call.argument("phoneNo");
                        readAllSms(phoneNumber);
                        result.success("success");
                    }
                }
        );
    }

    private List<Sms> getAllMessage() {
        List<Sms> smsList = new ArrayList<>();
        ContentResolver cr = this.getContentResolver();
        Uri uri = Uri.parse("content://sms/");
        Cursor c = cr.query(uri, null, null, null, null);

        if(c.moveToFirst()){
            do {
                Sms sms = new Sms();
                sms.setId(c.getString(c.getColumnIndexOrThrow(Telephony.Sms._ID)));
                sms.setAddress(c.getString(c.getColumnIndexOrThrow(Telephony.Sms.ADDRESS)));
                sms.setBody(c.getString(c.getColumnIndexOrThrow(Telephony.Sms.BODY)));
                int isRead = c.getInt(c.getColumnIndexOrThrow(Telephony.Sms.READ));
                if(isRead == 0) {
                    sms.setRead(false);
                }else {
                    sms.setRead(true);
                }
                sms.setDate(c.getString(c.getColumnIndexOrThrow(Telephony.Sms.DATE)));
                sms.setDateSent(c.getString(c.getColumnIndexOrThrow(Telephony.Sms.DATE_SENT)));
                sms.setThreadId(c.getString(c.getColumnIndexOrThrow(Telephony.Sms.THREAD_ID)));
                sms.setStatus(c.getString(c.getColumnIndexOrThrow(Telephony.Sms.STATUS)));
                int kind = c.getInt(c.getColumnIndexOrThrow("type"));
                if (kind == 1) {
                    sms.setType("INBOX");
                } else if(kind == 2)  {
                    sms.setType("SENT");
                }
                smsList.add(sms);
            }
            while (c.moveToNext());
        }
        if(c != null){
            c.close();
        }
        return smsList;
    }

    private void readAllSms(String phoneNo){
        Uri uri = Uri.parse("content://sms/");
        String selection = "address='" + phoneNo + "' and read=" + 0;
        Cursor cursor = getContentResolver().query(uri, null, selection, null, null);
        try {
            if (cursor.moveToFirst()) {
                do {
                    int smsId = cursor.getInt(cursor.getColumnIndex("_id"));
                    ContentValues contentValues = new ContentValues();
                    contentValues.put("read", 1);
                    getContentResolver().update(Uri.parse("content://sms/inbox"), contentValues, "_id=" + smsId, null);
                } while (cursor.moveToNext());
            }
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
        if (cursor!= null) {
            cursor.close();
        }
    }

    private Contact getContactByPhone(String phoneNumber){
        Bitmap bp = null;
        Uri uri = Uri.withAppendedPath(ContactsContract.Contacts.CONTENT_FILTER_URI, Uri.encode(phoneNumber));
        ContentResolver cr = this.getContentResolver();
        Cursor c = cr.query(uri, null, null, null, null);
        Contact contact = null;
        if(c.moveToFirst()){
            contact = new Contact();
            contact.setDisplayName(c.getString(c.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME)));
            String contactId = c.getString(c.getColumnIndexOrThrow(ContactsContract.Contacts._ID));
            contact.setId(contactId);
            //byte[] photoBytes = getPhoto(contactId);
            contact.setPhoto(getPhoto(contactId));
           /** get Number Phone
           if (c.getInt(c.getColumnIndex(
                    ContactsContract.Contacts.HAS_PHONE_NUMBER)) > 0) {
                Cursor pCur = cr.query(
                        ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                        null,
                        ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = ?",
                        new String[]{id}, null);
                if (pCur.moveToFirst()) {
                    contact.setPhoneNumber(pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE)));
                }
                pCur.close();
            }
            **/
        }
        if(c != null){
            c.close();
        }
        return contact;
    }

    public String getPhoto(String contactId){
        Uri contactUri = ContentUris.withAppendedId(ContactsContract.Contacts.CONTENT_URI, Long.parseLong(contactId));
        Uri photoUri = Uri.withAppendedPath(contactUri, ContactsContract.Contacts.Photo.CONTENT_DIRECTORY);
        Cursor c = getContentResolver().query(photoUri, new String[] {ContactsContract.Contacts.Photo.PHOTO}, null, null, null);
        if(c == null){
            return null;
        }
        try {
            if(c.moveToFirst()){
                byte[] data = c.getBlob(0);
                if(data != null){
                    return Base64.encodeToString(data, Base64.NO_WRAP);
                }
            }
        }finally {
            c.close();
        }
        return null;
    }
}
