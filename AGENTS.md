# Agent Notes

## Free web / cost-control reference

Before changing hosting, Firebase usage, cloud sync, bundled content, or
external content sources, read `docs/free-web-stack-reference.md`.

## JLPT exam / audio source reference

Before changing JLPT mock exams, listening/audio, scoring, answer sheets, or
exam-source imports, read `docs/jlpt-exam-source-reference.md`.

## Test account

Use this Firebase Auth account only for manual QA/test login flows:

- Email: `admin@jpstudy.test`
- Password: `adminadmin`
- Firebase UID: `iE3tNLHW7tTvTAL7WmSG2JyIovI2`
- Role: normal user; no production admin privileges/custom claims.
- Purpose: quick user-login simulation on https://jpstudy.web.app.

Do not grant elevated privileges to this account without explicit user request.
Do not rotate/delete it unless explicitly requested.
