<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>StudyApp Nigeria</title>
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Segoe UI', sans-serif; background: #0f0f1a; color: #e0e0e0; min-height: 100vh; }
  
  .screen { display: none; padding: 20px; max-width: 480px; margin: 0 auto; }
  .screen.active { display: block; }

  h1 { color: #7c6af7; font-size: 28px; margin-bottom: 4px; }
  h2 { color: #7c6af7; font-size: 20px; margin-bottom: 16px; }
  p.sub { color: #888; font-size: 13px; margin-bottom: 24px; }

  input, select {
    width: 100%; padding: 12px; margin-bottom: 12px;
    background: #1a1a2e; border: 1px solid #2a2a4a;
    border-radius: 8px; color: #e0e0e0; font-size: 15px;
  }
  input:focus, select:focus { outline: none; border-color: #7c6af7; }

  button {
    width: 100%; padding: 13px; border: none; border-radius: 8px;
    font-size: 15px; font-weight: 600; cursor: pointer; margin-bottom: 10px;
  }
  .btn-primary { background: #7c6af7; color: white; }
  .btn-primary:hover { background: #6a59e0; }
  .btn-secondary { background: #1a1a2e; color: #7c6af7; border: 1px solid #7c6af7; }
  .btn-danger { background: #e74c3c; color: white; }

  .card {
    background: #1a1a2e; border: 1px solid #2a2a4a;
    border-radius: 12px; padding: 16px; margin-bottom: 12px;
  }
  .card h3 { color: #7c6af7; margin-bottom: 4px; }
  .card p { color: #888; font-size: 13px; }

  .option-btn {
    width: 100%; text-align: left; padding: 12px 16px;
    background: #1a1a2e; border: 1px solid #2a2a4a;
    border-radius: 8px; color: #e0e0e0; font-size: 14px;
    cursor: pointer; margin-bottom: 8px;
  }
  .option-btn:hover { border-color: #7c6af7; }
  .option-btn.correct { border-color: #2ecc71; background: #0d2b1a; color: #2ecc71; }
  .option-btn.wrong { border-color: #e74c3c; background: #2b0d0d; color: #e74c3c; }

  .timer {
    background: #7c6af7; color: white; padding: 8px 16px;
    border-radius: 20px; font-weight: bold; display: inline-block;
    margin-bottom: 16px;
  }
  .timer.urgent { background: #e74c3c; }

  .progress { background: #2a2a4a; border-radius: 4px; height: 6px; margin-bottom: 20px; }
  .progress-bar { background: #7c6af7; height: 6px; border-radius: 4px; transition: width 0.3s; }

  .score-circle {
    width: 120px; height: 120px; border-radius: 50%;
    border: 4px solid #7c6af7; display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    margin: 20px auto; font-size: 28px; font-weight: bold; color: #7c6af7;
  }
  .score-circle span { font-size: 12px; color: #888; font-weight: normal; }

  .rank-item {
    display: flex; align-items: center; gap: 12px;
    background: #1a1a2e; border: 1px solid #2a2a4a;
    border-radius: 8px; padding: 12px; margin-bottom: 8px;
  }
  .rank-num { font-size: 18px; font-weight: bold; color: #7c6af7; width: 30px; }
  .rank-info { flex: 1; }
  .rank-info strong { display: block; }
  .rank-info small { color: #888; }
  .rank-score { font-weight: bold; color: #2ecc71; }

  .nav {
    display: flex; justify-content: space-around;
    background: #1a1a2e; border-top: 1px solid #2a2a4a;
    position: fixed; bottom: 0; left: 0; right: 0; padding: 10px 0;
  }
  .nav-btn {
    background: none; border: none; color: #888;
    font-size: 11px; cursor: pointer; display: flex;
    flex-direction: column; align-items: center; gap: 4px; width: auto;
    margin: 0; padding: 4px 12px;
  }
  .nav-btn.active { color: #7c6af7; }
  .nav-btn svg { width: 22px; height: 22px; }

  .main-content { padding-bottom: 80px; }
  .msg { padding: 10px; border-radius: 8px; margin-bottom: 12px; font-size: 14px; text-align: center; }
  .msg.error { background: #2b0d0d; color: #e74c3c; }
  .msg.success { background: #0d2b1a; color: #2ecc71; }

  .logo-area { text-align: center; padding: 40px 0 30px; }
  .logo-area h1 { font-size: 36px; }
  .logo-area p { color: #888; margin-top: 8px; }
  
  .tab-row { display: flex; gap: 8px; margin-bottom: 16px; }
  .tab { flex: 1; padding: 10px; text-align: center; border-radius: 8px;
    background: #1a1a2e; border: 1px solid #2a2a4a; cursor: pointer;
    color: #888; font-size: 14px; }
  .tab.active { background: #7c6af7; color: white; border-color: #7c6af7; }

  .explanation { 
    background: #0d1b2b; border: 1px solid #1a4a7a; 
    border-radius: 8px; padding: 12px; margin-top: 12px;
    font-size: 14px; color: #88aacc; display: none;
  }
</style>
</head>
<body>

<!-- AUTH SCREEN -->
<div id="authScreen" class="screen active">
  <div class="logo-area">
    <h1>📚 StudyApp</h1>
    <p>Nigeria's CBT Practice Platform</p>
  </div>

  <div class="tab-row">
    <div class="tab active" onclick="switchTab('login')">Login</div>
    <div class="tab" onclick="switchTab('signup')">Sign Up</div>
  </div>

  <div id="loginForm">
    <input type="email" id="loginEmail" placeholder="Email address">
    <input type="password" id="loginPassword" placeholder="Password">
    <div id="loginMsg" class="msg" style="display:none"></div>
    <button class="btn-primary" onclick="login()">Login</button>
  </div>

  <div id="signupForm" style="display:none">
    <input type="text" id="signupName" placeholder="Full name">
    <input type="email" id="signupEmail" placeholder="Email address">
    <input type="password" id="signupPassword" placeholder="Password (min 6 characters)">
    <input type="text" id="signupUni" placeholder="University (e.g. UNN)">
    <input type="text" id="signupDept" placeholder="Department (e.g. Medicine)">
    <select id="signupLevel">
      <option value="">Select Level</option>
      <option>100L</option><option>200L</option><option>300L</option>
      <option>400L</option><option>500L</option><option>600L</option>
    </select>
    <div id="signupMsg" class="msg" style="display:none"></div>
    <button class="btn-primary" onclick="signup()">Create Account</button>
  </div>
</div>

<!-- HOME SCREEN -->
<div id="homeScreen" class="screen">
  <div class="main-content">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; padding-top:10px">
      <div>
        <h2 style="margin:0" id="welcomeName">Welcome back!</h2>
        <p style="color:#888; font-size:13px" id="welcomeSub">Ready to study?</p>
      </div>
      <button onclick="logout()" style="width:auto; padding:8px 14px; background:#1a1a2e; border:1px solid #2a2a4a; border-radius:8px; color:#888; font-size:13px; cursor:pointer">Logout</button>
    </div>

    <div class="card" style="background: linear-gradient(135deg, #7c6af7, #5a4fcf); border:none">
      <h3 style="color:white; font-size:18px">Start Practicing</h3>
      <p style="color:rgba(255,255,255,0.8); margin-bottom:12px">Pick a course and test yourself</p>
      <button onclick="showScreen('coursesScreen')" style="width:auto; padding:8px 20px; background:white; color:#7c6af7; border:none; border-radius:8px; font-weight:600; cursor:pointer">Browse Courses →</button>
    </div>

    <h2 style="margin-bottom:12px">Your Stats</h2>
    <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:20px">
      <div class="card" style="text-align:center">
        <div style="font-size:28px; font-weight:bold; color:#7c6af7" id="statExams">0</div>
        <div style="font-size:12px; color:#888">Exams Taken</div>
      </div>
      <div class="card" style="text-align:center">
        <div style="font-size:28px; font-weight:bold; color:#2ecc71" id="statAvg">0%</div>
        <div style="font-size:12px; color:#888">Average Score</div>
      </div>
    </div>

    <h2 style="margin-bottom:12px">Recent Results</h2>
    <div id="recentResults"><p style="color:#888; font-size:14px">No exams taken yet. Start practicing!</p></div>
  </div>
  <div class="nav">
    <button class="nav-btn active" onclick="showScreen('homeScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>Home
    </button>
    <button class="nav-btn" onclick="showScreen('coursesScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/></svg>Courses
    </button>
    <button class="nav-btn" onclick="showScreen('leaderboardScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>Rankings
    </button>
  </div>
</div>

<!-- COURSES SCREEN -->
<div id="coursesScreen" class="screen">
  <div class="main-content">
    <div style="display:flex; align-items:center; gap:12px; margin-bottom:20px; padding-top:10px">
      <button onclick="showScreen('homeScreen')" style="width:auto; background:none; border:none; color:#7c6af7; font-size:20px; cursor:pointer">←</button>
      <h2 style="margin:0">Courses</h2>
    </div>
    <div id="coursesList"><p style="color:#888">Loading courses...</p></div>
  </div>
  <div class="nav">
    <button class="nav-btn" onclick="showScreen('homeScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>Home
    </button>
    <button class="nav-btn active" onclick="showScreen('coursesScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/></svg>Courses
    </button>
    <button class="nav-btn" onclick="showScreen('leaderboardScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>Rankings
    </button>
  </div>
</div>

<!-- EXAM SCREEN -->
<div id="examScreen" class="screen">
  <div style="padding-top:10px">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px">
      <div id="examTitle" style="font-weight:600; color:#7c6af7"></div>
      <div id="timerDisplay" class="timer">15:00</div>
    </div>
    <div class="progress"><div class="progress-bar" id="progressBar" style="width:0%"></div></div>
    <div id="questionCounter" style="color:#888; font-size:13px; margin-bottom:12px"></div>
    <div id="questionText" style="font-size:16px; font-weight:500; margin-bottom:20px; line-height:1.5"></div>
    <div id="optionsContainer"></div>
    <div id="explanationBox" class="explanation"></div>
    <button id="nextBtn" class="btn-primary" onclick="nextQuestion()" style="margin-top:16px; display:none">Next Question →</button>
    <button id="submitBtn" class="btn-danger" onclick="submitExam()" style="margin-top:16px; display:none">Submit Exam</button>
  </div>
</div>

<!-- RESULTS SCREEN -->
<div id="resultsScreen" class="screen">
  <div style="padding-top:20px; text-align:center">
    <h2>Exam Complete!</h2>
    <div class="score-circle" id="scoreCircle">
      <div id="scorePercent">0%</div>
      <span>Score</span>
    </div>
    <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:10px; margin:20px 0">
      <div class="card" style="text-align:center; padding:12px">
        <div style="font-size:20px; font-weight:bold; color:#2ecc71" id="resCorrect">0</div>
        <div style="font-size:11px; color:#888">Correct</div>
      </div>
      <div class="card" style="text-align:center; padding:12px">
        <div style="font-size:20px; font-weight:bold; color:#e74c3c" id="resWrong">0</div>
        <div style="font-size:11px; color:#888">Wrong</div>
      </div>
      <div class="card" style="text-align:center; padding:12px">
        <div style="font-size:20px; font-weight:bold; color:#f39c12" id="resTime">0s</div>
        <div style="font-size:11px; color:#888">Time Used</div>
      </div>
    </div>
    <button class="btn-primary" onclick="showScreen('coursesScreen')">Practice Again</button>
    <button class="btn-secondary" onclick="showScreen('homeScreen')">Back to Home</button>
  </div>
</div>

<!-- LEADERBOARD SCREEN -->
<div id="leaderboardScreen" class="screen">
  <div class="main-content">
    <div style="padding-top:10px; margin-bottom:20px">
      <h2>Rankings</h2>
      <p style="color:#888; font-size:13px">Top performers this week</p>
    </div>
    <div id="leaderboardList"><p style="color:#888">Loading rankings...</p></div>
  </div>
  <div class="nav">
    <button class="nav-btn" onclick="showScreen('homeScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>Home
    </button>
    <button class="nav-btn" onclick="showScreen('coursesScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 016.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/></svg>Courses
    </button>
    <button class="nav-btn active" onclick="showScreen('leaderboardScreen')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>Rankings
    </button>
  </div>
</div>

<script>
// ==============================
// CONFIGURATION — REPLACE THESE
// ==============================
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1qam9tZmRpa3Z5ZWpoenJ4ZGVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEyNTg2NjYsImV4cCI6MjA5NjgzNDY2Nn0.3NMR2qiHHZJk_PoQRXufDqKu1OXQa4hzvr1Tl7VKy6I';';
// ==============================

const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

let currentUser = null;
let currentProfile = null;
let examQuestions = [];
let currentQ = 0;
let score = 0;
let answered = false;
let timerInterval = null;
let timeLeft = 0;
let examStartTime = null;
let currentCourse = null;

// ── NAVIGATION ──
function showScreen(id) {
  document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));
  document.getElementById(id).classList.add('active');
  document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
  if (id === 'homeScreen') { loadHomeStats(); document.querySelectorAll('.nav-btn')[0].classList.add('active'); }
  if (id === 'coursesScreen') { loadCourses(); document.querySelectorAll('.nav-btn')[1].classList.add('active'); }
  if (id === 'leaderboardScreen') { loadLeaderboard(); document.querySelectorAll('.nav-btn')[2].classList.add('active'); }
}

function switchTab(tab) {
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  event.target.classList.add('active');
  document.getElementById('loginForm').style.display = tab === 'login' ? 'block' : 'none';
  document.getElementById('signupForm').style.display = tab === 'signup' ? 'block' : 'none';
}

// ── AUTH ──
async function signup() {
  const name = document.getElementById('signupName').value.trim();
  const email = document.getElementById('signupEmail').value.trim();
  const password = document.getElementById('signupPassword').value;
  const university = document.getElementById('signupUni').value.trim();
  const department = document.getElementById('signupDept').value.trim();
  const level = document.getElementById('signupLevel').value;
  const msg = document.getElementById('signupMsg');

  if (!name || !email || !password || !university || !department || !level) {
    showMsg(msg, 'Please fill in all fields', 'error'); return;
  }

  const { data, error } = await db.auth.signUp({ email, password });
  if (error) { showMsg(msg, error.message, 'error'); return; }

  await db.from('profiles').insert({ id: data.user.id, name, university, department, level });
  showMsg(msg, 'Account created! Please check your email to verify.', 'success');
}

async function login() {
  const email = document.getElementById('loginEmail').value.trim();
  const password = document.getElementById('loginPassword').value;
  const msg = document.getElementById('loginMsg');

  const { data, error } = await db.auth.signInWithPassword({ email, password });
  if (error) { showMsg(msg, 'Invalid email or password', 'error'); return; }

  currentUser = data.user;
  await loadProfile();
  showScreen('homeScreen');
}

async function logout() {
  await db.auth.signOut();
  currentUser = null; currentProfile = null;
  showScreen('authScreen');
}

async function loadProfile() {
  const { data } = await db.from('profiles').select('*').eq('id', currentUser.id).single();
  currentProfile = data;
  if (data) {
    document.getElementById('welcomeName').textContent = `Hey, ${data.name.split(' ')[0]}! 👋`;
    document.getElementById('welcomeSub').textContent = `${data.department} • ${data.level}`;
  }
}

// ── HOME STATS ──
async function loadHomeStats() {
  if (!currentUser) return;
  const { data } = await db.from('results').select('*').eq('user_id', currentUser.id);
  if (!data || data.length === 0) return;

  document.getElementById('statExams').textContent = data.length;
  const avg = data.reduce((sum, r) => sum + Math.round((r.score / r.total) * 100), 0) / data.length;
  document.getElementById('statAvg').textContent = Math.round(avg) + '%';

  const recent = data.slice(-3).reverse();
  const html = recent.map(r => `
    <div class="card" style="display:flex; justify-content:space-between; align-items:center">
      <div><strong style="font-size:14px">Exam Result</strong><br><small style="color:#888">${new Date(r.created_at).toLocaleDateString()}</small></div>
      <div style="font-weight:bold; color:#7c6af7; font-size:18px">${Math.round((r.score/r.total)*100)}%</div>
    </div>`).join('');
  document.getElementById('recentResults').innerHTML = html;
}

// ── COURSES ──
async function loadCourses() {
  const { data } = await db.from('courses').select('*');
  const list = document.getElementById('coursesList');
  if (!data || data.length === 0) {
    list.innerHTML = `<div class="card"><h3>No courses yet</h3><p>Courses will appear here once added by your admin.</p></div>`; return;
  }
  list.innerHTML = data.map(c => `
    <div class="card" style="cursor:pointer" onclick="startExam(${c.id}, '${c.course_code}', '${c.course_title}')">
      <h3>${c.course_code}</h3>
      <p>${c.course_title}</p>
      <p style="color:#7c6af7; font-size:13px; margin-top:8px">Tap to start CBT →</p>
    </div>`).join('');
}

// ── EXAM ENGINE ──
async function startExam(courseId, code, title) {
  const { data } = await db.from('questions').select('*').eq('course_id', courseId);
  if (!data || data.length === 0) {
    alert('No questions available for this course yet.'); return;
  }

  examQuestions = shuffle(data).slice(0, Math.min(20, data.length));
  currentQ = 0; score = 0; answered = false;
  currentCourse = { id: courseId, code, title };
  examStartTime = Date.now();
  timeLeft = examQuestions.length * 45;

  showScreen('examScreen');
  document.getElementById('examTitle').textContent = code;
  startTimer();
  renderQuestion();
}

function renderQuestion() {
  const q = examQuestions[currentQ];
  const total = examQuestions.length;
  answered = false;

  document.getElementById('questionCounter').textContent = `Question ${currentQ + 1} of ${total}`;
  document.getElementById('progressBar').style.width = `${((currentQ) / total) * 100}%`;
  document.getElementById('questionText').textContent = q
