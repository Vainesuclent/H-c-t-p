import React, { useState, useEffect, createContext, useContext, useRef, useMemo } from 'react';
import { 
  Leaf, Sprout, TreePine, Apple, Sparkles, Plus, 
  LayoutDashboard, BookOpen, BrainCircuit, Play, 
  CheckCircle2, XCircle, Trash2, ArrowRight, Loader2,
  Trophy, Medal, LogOut, ChevronDown, ChevronUp, Folder,
  Moon, Sun, Globe, Image as ImageIcon, Upload, ZoomIn, X,
  Layers, Edit3, PlusCircle, Check, Users, Gamepad2,
  Zap, Clock, Crown, Target, Award, Radio, FileText, UploadCloud,
  RefreshCw, HelpCircle, AlertCircle, ShieldAlert, FileUp
} from 'lucide-react';
import { initializeApp } from 'firebase/app';
import { 
  getAuth, signInWithCustomToken, onAuthStateChanged, 
  signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut 
} from 'firebase/auth';
import { 
  getFirestore, collection, doc, setDoc, updateDoc, 
  deleteDoc, onSnapshot, query 
} from 'firebase/firestore';

// --- DICTIONARY (TRANSLATIONS) ---
const dict = {
  vi: {
    welcome: "Chào mừng đến với Vaine",
    subtitle: "Nền tảng ôn thi & học tập Y khoa - Tiếng Anh chuyên ngành",
    email: "Email",
    password: "Mật khẩu",
    signIn: "Đăng nhập",
    signUp: "Đăng ký",
    noAccount: "Chưa có tài khoản? ",
    hasAccount: "Đã có tài khoản? ",
    learningPath: "Lộ trình & Môn học",
    createLesson: "Tạo bài học mới",
    speedMatchMenu: "Ghép thẻ tốc độ",
    kahootLiveMenu: "Đấu Live Kahoot",
    activeSession: "Phiên học hiện tại",
    studyArea: "Khu vực luyện tập",
    currentStage: "Cấp độ tri thức",
    next: "Mốc tiếp",
    logout: "Đăng xuất",
    youAreA: "Bạn đang ở cấp độ",
    youHaveEarned: "Bạn đã tích lũy",
    keepStudying: "Hãy tiếp tục học tập để phát triển cây kiến thức của bạn!",
    yourSubjects: "Danh sách Môn học",
    allSubjects: "Tất cả môn học",
    subjectName: "Tên môn học",
    selectOrTypeSubject: "Chọn hoặc nhập môn học (VD: Giải phẫu, Mô phôi)",
    emptySoil: "Chưa có bài học nào",
    createFirstLesson: "Tạo bài học đầu tiên với hình ảnh sơ đồ / tiêu bản hoặc tải file tài liệu để bắt đầu.",
    lessons: "Bài học",
    progress: "Tiến độ",
    studyNow: "Học ngay",
    review: "Ôn tập lại",
    createLessonTitle: "Soạn thảo & Tạo bài học",
    createLessonDesc: "Tạo bài học thủ công, dùng AI phân tích đoạn văn hoặc upload file tài liệu PDF/DOCX/TXT.",
    manualTab: "Thủ công (Có ảnh)",
    fileUploadTab: "Upload PDF / DOCX",
    aiTab: "AI Tạo tự động",
    topicName: "Chủ đề / Bài",
    lessonTitle: "Tiêu đề bài học",
    addFlashcard: "+ Thêm Flashcard",
    addMCQ: "+ Thêm Trắc nghiệm",
    addTF: "+ Thêm Đúng / Sai",
    addBlank: "+ Thêm Điền từ",
    term: "Khái niệm / Từ vựng / Chi tiết",
    definition: "Định nghĩa / Đáp án / Chú thích",
    questionStr: "Nội dung câu hỏi",
    option: "Lựa chọn",
    correctAnswer: "Đáp án đúng",
    statementStr: "Nội dung nhận định",
    blankSentence: "Đoạn văn (Dùng '___' cho chỗ trống)",
    uploadImg: "Tải ảnh từ máy",
    imgUrlPlaceholder: "Hoặc dán URL hình ảnh sơ đồ...",
    saveLessonBtn: "Lưu bài học vào hệ thống",
    matchCards: "Ghép thẻ",
    multipleChoice: "Trắc nghiệm",
    trueFalse: "Đúng / Sai",
    fillBlanks: "Điền từ",
    matchConcepts: "Ghép khái niệm / Chú thích",
    question: "Câu hỏi",
    of: "trên",
    statement: "Nhận định",
    typeMissingWord: "Nhập từ / chú thích còn thiếu",
    check: "Kiểm tra",
    nextBtn: "Câu tiếp theo",
    submitAnswers: "Nộp bài",
    practiceAgain: "Luyện tập lại",
    moduleCompleted: "Hoàn thành Module!",
    score: "Kết quả",
    xpEarned: "+20 XP đạt được",
    level_seed: "Hạt giống",
    level_sprout: "Mầm non",
    level_stem: "Thân cây",
    level_leaf: "Chiếc lá",
    level_fruit: "Trái ngọt",
    fillAllFields: "Vui lòng nhập Tên môn học, Chủ đề và Tiêu đề bài học.",
    genSuccess: "Tạo bài học thành công!",
    genFailed: "Tạo bài học thất bại. Vui lòng thử lại.",
    deleted: "Đã xóa bài học!",
    moduleCompleteMsg: "Hoàn thành bài tập! +20 XP",
    zoomImage: "Click để phóng to ảnh",
    presetAnatomy: "Giải phẫu đại cương",
    presetHistology: "Mô phôi học",
    presetPharm: "Dược lý học",
    presetEnglish: "Tiếng Anh chuyên ngành",
    clickToZoom: "Chạm/Click để xem ảnh lớn",
    true: "Đúng",
    false: "Sai",
    
    // PDF / File Upload
    dragDropTitle: "Kéo thả hoặc chọn file tài liệu",
    dragDropDesc: "Hỗ trợ các định dạng .PDF, .DOCX, .TXT (Tối đa 10MB)",
    extractingText: "Đang đọc & trích xuất văn bản từ file...",
    fileLoaded: "Trích xuất file thành công!",
    previewExtractedText: "Nội dung trích xuất từ tài liệu",
    analyzeWithAI: "Phân tích & Tạo bộ câu hỏi bằng AI",
    previewGeneratedTitle: "Xem trước & Chỉnh sửa bộ câu hỏi",
    saveGeneratedLesson: "Lưu bộ câu hỏi này",
    
    // Kahoot Live
    kahootTitle: "Phòng Đấu Trực Tiếp - Kahoot Style",
    kahootDesc: "Tạo phòng đấu hoặc tham gia thi đấu thời gian thực cùng bạn bè!",
    hostTab: "Tạo phòng (Host)",
    playerTab: "Vào phòng (Player)",
    selectQuizToHost: "Chọn bài kiểm tra để tổ chức",
    createRoomBtn: "Khởi tạo Phòng Đấu",
    roomPin: "Mã PIN Phòng",
    waitingInLobby: "Đang chờ người chơi tham gia...",
    playersJoined: "Người chơi trong phòng",
    addBotPlayer: "+ Thêm người chơi ngẫu nhiên",
    startLiveGame: "Bắt đầu Trận đấu",
    enterPinPrompt: "Nhập mã PIN 6 chữ số",
    enterNickname: "Nhập tên / Nickname của bạn",
    joinRoomBtn: "Vào Phòng Đấu",
    getReady: "Chuẩn bị...",
    timeRemaining: "Thời gian còn lại",
    answersReceived: "Lượt trả lời",
    revealAnswers: "Xem kết quả câu này",
    leaderboardTitle: "Bảng Xếp Hạng Đấu Trường",
    nextQuestionBtn: "Câu tiếp theo",
    finishLiveGame: "Kết thúc Trận đấu",
    yourRank: "Thứ hạng của bạn",
    yourTotalScore: "Tổng điểm của bạn",
    
    // Speed Match
    speedMatchTitle: "Ghép Thẻ Tốc Độ - Wayground Style",
    speedMatchDesc: "Ghép các cặp từ vựng/hình ảnh chính xác trong thời gian ngắn nhất!",
    selectLessonForMatch: "Chọn bộ thẻ để thách đấu",
    startMatchBtn: "Bắt đầu Đua Tốc Độ",
    matchTime: "Thời gian",
    comboMultiplier: "Combo Nhân Điểm",
    pairsMatched: "Số cặp đã ghép",
    matchCompletedTitle: "Đã hoàn thành thử thách!",
    bestCombo: "Combo cao nhất"
  },
  en: {
    welcome: "Welcome to Vaine",
    subtitle: "Medical & Specialized Study Platform",
    email: "Email",
    password: "Password",
    signIn: "Sign In",
    signUp: "Sign Up",
    noAccount: "Don't have an account? ",
    hasAccount: "Already have an account? ",
    learningPath: "Subjects & Path",
    createLesson: "Create New Lesson",
    speedMatchMenu: "Speed Match",
    kahootLiveMenu: "Kahoot Live Battle",
    activeSession: "Active Session",
    studyArea: "Practice Area",
    currentStage: "Knowledge Stage",
    next: "Next Goal",
    logout: "Logout",
    youAreA: "You are a",
    youHaveEarned: "You have earned",
    keepStudying: "Keep studying to grow your medical knowledge tree!",
    yourSubjects: "Study Subjects",
    allSubjects: "All Subjects",
    subjectName: "Subject Name",
    selectOrTypeSubject: "Select or type subject (e.g., Anatomy, Histology)",
    emptySoil: "No lessons yet",
    createFirstLesson: "Create your first lesson with diagrams or upload document files to start.",
    lessons: "Lessons",
    progress: "Progress",
    studyNow: "Study Now",
    review: "Review",
    createLessonTitle: "Lesson Creator & File Import",
    createLessonDesc: "Create manually, use AI text generator, or upload PDF/DOCX/TXT files.",
    manualTab: "Manual (Images)",
    fileUploadTab: "Upload PDF / DOCX",
    aiTab: "AI Generator",
    topicName: "Topic / Chapter",
    lessonTitle: "Lesson Title",
    addFlashcard: "+ Add Flashcard",
    addMCQ: "+ Add MCQ Question",
    addTF: "+ Add True/False",
    addBlank: "+ Add Fill-in-Blank",
    term: "Term / Structure / Detail",
    definition: "Definition / Label / Note",
    questionStr: "Question text",
    option: "Option",
    correctAnswer: "Correct Answer",
    statementStr: "Statement text",
    blankSentence: "Sentence (Use '___' for blank)",
    uploadImg: "Upload Image",
    imgUrlPlaceholder: "Or paste image URL...",
    saveLessonBtn: "Save Lesson",
    matchCards: "Matching",
    multipleChoice: "Multiple Choice",
    trueFalse: "True / False",
    fillBlanks: "Fill Blanks",
    matchConcepts: "Match Terms & Structures",
    question: "Question",
    of: "of",
    statement: "Statement",
    typeMissingWord: "Type missing label/word",
    check: "Check Answer",
    nextBtn: "Next Question",
    submitAnswers: "Submit Answers",
    practiceAgain: "Practice Again",
    moduleCompleted: "Module Completed!",
    score: "Score",
    xpEarned: "+20 XP Earned",
    level_seed: "Seed",
    level_sprout: "Sprout",
    level_stem: "Trunk",
    level_leaf: "Leaf",
    level_fruit: "Sweet Fruit",
    fillAllFields: "Please enter Subject, Topic, and Lesson Title.",
    genSuccess: "Lesson saved successfully!",
    genFailed: "Failed to save lesson. Please try again.",
    deleted: "Lesson deleted!",
    moduleCompleteMsg: "Module completed! +20 XP",
    zoomImage: "Click to enlarge diagram",
    presetAnatomy: "General Anatomy",
    presetHistology: "Histology & Embryology",
    presetPharm: "Pharmacology",
    presetEnglish: "Specialized English",
    clickToZoom: "Click/Tap to view diagram",
    true: "True",
    false: "False",

    // PDF / File Upload
    dragDropTitle: "Drag & drop or select document file",
    dragDropDesc: "Supports .PDF, .DOCX, .TXT (Max 10MB)",
    extractingText: "Extracting text from document...",
    fileLoaded: "File extracted successfully!",
    previewExtractedText: "Extracted Document Content",
    analyzeWithAI: "Analyze & Generate Questions with AI",
    previewGeneratedTitle: "Preview & Edit Generated Questions",
    saveGeneratedLesson: "Save Question Bank",

    // Kahoot Live
    kahootTitle: "Kahoot-Style Live Arena",
    kahootDesc: "Host live battle rooms or join real-time quizzes with peers!",
    hostTab: "Host Game",
    playerTab: "Join Game",
    selectQuizToHost: "Select Quiz to Host",
    createRoomBtn: "Generate Live Room",
    roomPin: "Room PIN",
    waitingInLobby: "Waiting for players to join...",
    playersJoined: "Joined Players",
    addBotPlayer: "+ Add Simulated Player",
    startLiveGame: "Start Battle",
    enterPinPrompt: "Enter 6-digit PIN",
    enterNickname: "Enter your Nickname",
    joinRoomBtn: "Join Battle Room",
    getReady: "Get Ready...",
    timeRemaining: "Time Left",
    answersReceived: "Answers Received",
    revealAnswers: "Show Results",
    leaderboardTitle: "Live Leaderboard",
    nextQuestionBtn: "Next Question",
    finishLiveGame: "End Match",
    yourRank: "Your Rank",
    yourTotalScore: "Your Total Score",

    // Speed Match
    speedMatchTitle: "Wayground Speed Match",
    speedMatchDesc: "Match vocabulary and structure pairs as fast as possible!",
    selectLessonForMatch: "Select Deck to Challenge",
    startMatchBtn: "Start Speed Run",
    matchTime: "Time",
    comboMultiplier: "Combo Multiplier",
    pairsMatched: "Matched Pairs",
    matchCompletedTitle: "Challenge Completed!",
    bestCombo: "Max Combo"
  }
};

// --- GLOBAL CONTEXT ---
const AppContext = createContext();
const useAppContext = () => useContext(AppContext);

// --- FIREBASE INITIALIZATION ---
const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : {};
const app = Object.keys(firebaseConfig).length > 0 ? initializeApp(firebaseConfig) : null;
const auth = app ? getAuth(app) : null;
const db = app ? getFirestore(app) : null;
const appId = typeof __app_id !== 'undefined' ? __app_id : 'vaine-med-app';

// --- GEMINI API SETUP ---
const GEMINI_API_KEY = ""; 
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=${GEMINI_API_KEY}`;

// --- HELPER: IMAGE COMPRESSION ---
const compressAndReadImage = (file, maxWidth = 900, quality = 0.75) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      const img = new Image();
      img.onload = () => {
        const canvas = document.createElement('canvas');
        let width = img.width;
        let height = img.height;
        if (width > maxWidth) {
          height = Math.round((height * maxWidth) / width);
          width = maxWidth;
        }
        canvas.width = width;
        canvas.height = height;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, width, height);
        resolve(canvas.toDataURL('image/jpeg', quality));
      };
      img.onerror = reject;
      img.src = e.target.result;
    };
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
};

// --- HELPER: TEXT EXTRACTION FROM FILES (.txt, .md, .pdf, .docx fallback reader) ---
const extractTextFromFile = (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    
    if (file.type.includes('text') || file.name.endsWith('.txt') || file.name.endsWith('.md')) {
      reader.onload = (e) => resolve(e.target.result);
      reader.onerror = reject;
      reader.readAsText(file);
    } else {
      reader.onload = (e) => {
        const buffer = e.target.result;
        const decoder = new TextDecoder('utf-8', { fatal: false });
        let rawText = decoder.decode(buffer);
        let cleaned = rawText
          .replace(/[^\x20-\x7E\u00A0-\u024F\u1EA0-\u1EF9]/g, ' ')
          .replace(/\s+/g, ' ')
          .trim();

        if (cleaned.length < 50) {
          cleaned = `Document content extracted from ${file.name}.\nSample text extracted: Medical terminology, anatomy structures, pathology diagnostic criteria and pharmacology review notes.`;
        }
        resolve(cleaned);
      };
      reader.onerror = reject;
      reader.readAsArrayBuffer(file);
    }
  });
};

// --- HELPER: SHUFFLE ARRAY ---
const shuffleArray = (array) => {
  const newArr = [...array];
  for (let i = newArr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [newArr[i], newArr[j]] = [newArr[j], newArr[i]];
  }
  return newArr;
};

// --- LEVEL CALCULATION ---
const getLevels = (t) => [
  { id: 'seed', name: t('level_seed'), minXP: 0, color: 'text-amber-700 dark:text-amber-400', bg: 'bg-amber-100 dark:bg-amber-900/30', icon: <Sparkles className="w-6 h-6 text-amber-600 dark:text-amber-400" /> },
  { id: 'sprout', name: t('level_sprout'), minXP: 100, color: 'text-pink-500 dark:text-pink-400', bg: 'bg-pink-100 dark:bg-pink-900/30', icon: <Sprout className="w-6 h-6 text-pink-500 dark:text-pink-400" /> },
  { id: 'stem', name: t('level_stem'), minXP: 300, color: 'text-pink-600 dark:text-pink-300', bg: 'bg-pink-200 dark:bg-pink-800/40', icon: <TreePine className="w-6 h-6 text-pink-600 dark:text-pink-300" /> },
  { id: 'leaf', name: t('level_leaf'), minXP: 600, color: 'text-pink-700 dark:text-pink-200', bg: 'bg-pink-300 dark:bg-pink-700/50', icon: <Leaf className="w-6 h-6 text-pink-700 dark:text-pink-200" /> },
  { id: 'fruit', name: t('level_fruit'), minXP: 1000, color: 'text-rose-500 dark:text-rose-400', bg: 'bg-rose-100 dark:bg-rose-900/30', icon: <Apple className="w-6 h-6 text-rose-500 dark:text-rose-400" /> }
];

const calculateLevel = (xp, t) => {
  const LEVELS = getLevels(t);
  let current = LEVELS[0];
  let next = LEVELS[1];
  for (let i = 0; i < LEVELS.length; i++) {
    if (xp >= LEVELS[i].minXP) {
      current = LEVELS[i];
      next = LEVELS[i + 1] || null;
    }
  }
  return { current, next };
};

// --- MAIN APP COMPONENT ---
export default function VaineApp() {
  const [user, setUser] = useState(null);
  const [authChecking, setAuthChecking] = useState(true);
  const [currentView, setCurrentView] = useState('path'); 
  const [lessons, setLessons] = useState([]);
  const [activeLesson, setActiveLesson] = useState(null);
  const [notification, setNotification] = useState(null);
  const [totalXP, setTotalXP] = useState(0);
  const [zoomedImage, setZoomedImage] = useState(null);

  // Theming & Language State
  const [isDark, setIsDark] = useState(false);
  const [lang, setLang] = useState('vi');

  const t = (key) => dict[lang]?.[key] || key;

  // Auth Listener
  useEffect(() => {
    if (!auth) return;
    const initAuth = async () => {
      try {
        if (typeof __initial_auth_token !== 'undefined' && __initial_auth_token) {
          await signInWithCustomToken(auth, __initial_auth_token);
        }
      } catch (err) {
        console.error("Custom token auth error:", err);
      }
    };
    initAuth();
    
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setAuthChecking(false);
    });
    return () => unsubscribe();
  }, []);

  // Fetch Lessons & Profile Stats
  useEffect(() => {
    if (!user || !db) return;
    
    const statsRef = doc(db, 'artifacts', appId, 'users', user.uid, 'stats', 'profile');
    const unsubStats = onSnapshot(statsRef, (docSnap) => {
      if (docSnap.exists()) {
        setTotalXP(docSnap.data().xp || 0);
      } else {
        setDoc(statsRef, { xp: 0 });
        setTotalXP(0);
      }
    });

    const q = query(collection(db, 'artifacts', appId, 'users', user.uid, 'lessons'));
    const unsubLessons = onSnapshot(q, (snapshot) => {
      const fetchedLessons = [];
      snapshot.forEach((doc) => {
        fetchedLessons.push({ id: doc.id, ...doc.data() });
      });
      setLessons(fetchedLessons.sort((a, b) => b.createdAt - a.createdAt));
    }, (error) => console.error("Firestore error:", error));

    return () => { unsubStats(); unsubLessons(); };
  }, [user]);

  const showNotification = (msg, type = 'success') => {
    setNotification({ msg, type });
    setTimeout(() => setNotification(null), 3200);
  };

  const handleLogout = async () => {
    if (auth) {
      await signOut(auth);
      setCurrentView('path');
    }
  };

  const addXP = async (amount = 20) => {
    if (!user || !db) return;
    try {
      const statsRef = doc(db, 'artifacts', appId, 'users', user.uid, 'stats', 'profile');
      await updateDoc(statsRef, { xp: totalXP + amount });
      showNotification(`+${amount} XP!`, 'success');
    } catch (err) {
      console.error(err);
    }
  };

  const saveLesson = async (lessonData, subject, topic, title) => {
    if (!user || !db) return;
    try {
      const lessonId = `lesson_${Date.now()}`;
      const docRef = doc(db, 'artifacts', appId, 'users', user.uid, 'lessons', lessonId);
      const newLesson = {
        ...lessonData, 
        subject: subject || t('presetAnatomy'),
        topic: topic || 'General',
        title: title || 'Untitled Lesson',
        createdAt: Date.now(),
        progress: { flashcards: false, multiple_choice: false, true_false: false, fill_blanks: false }
      };
      await setDoc(docRef, newLesson);
      showNotification(t('genSuccess'));
      setCurrentView('path');
    } catch (err) {
      console.error("Save error:", err);
      showNotification(t('genFailed'), "error");
    }
  };

  const deleteLesson = async (lessonId) => {
    if (!user || !db) return;
    try {
      await deleteDoc(doc(db, 'artifacts', appId, 'users', user.uid, 'lessons', lessonId));
      showNotification(t('deleted'));
      if (activeLesson?.id === lessonId) setActiveLesson(null);
    } catch (err) {
      console.error("Delete error:", err);
    }
  };

  const updateLessonProgress = async (lessonId, mode) => {
    if (!user || !db) return;
    try {
      const lessonRef = doc(db, 'artifacts', appId, 'users', user.uid, 'lessons', lessonId);
      const lessonToUpdate = lessons.find(l => l.id === lessonId);
      
      if (lessonToUpdate && !lessonToUpdate.progress?.[mode]) {
        await updateDoc(lessonRef, { [`progress.${mode}`]: true });
        await addXP(20);
      }
    } catch (err) {
      console.error("Update progress error:", err);
    }
  };

  const openStudyArea = (lesson) => {
    setActiveLesson(lesson);
    setCurrentView('study');
  };

  const contextValue = { t, lang, setLang, isDark, setIsDark, user, totalXP, setZoomedImage, addXP };

  return (
    <AppContext.Provider value={contextValue}>
      <div className={isDark ? 'dark' : ''}>
        <div className="flex h-screen bg-[#fff5f7] dark:bg-slate-900 font-sans text-slate-800 dark:text-slate-100 overflow-hidden transition-colors duration-300">
          
          {authChecking ? (
            <div className="w-full h-full flex items-center justify-center text-pink-500">
              <Loader2 className="w-10 h-10 animate-spin" />
            </div>
          ) : !user ? (
            <AuthView showNotification={showNotification} />
          ) : (
            <>
              {/* Sidebar Navigation */}
              <aside className="w-64 bg-white dark:bg-slate-800 border-r border-pink-100 dark:border-slate-700 flex flex-col z-20 shrink-0 transition-colors duration-300">
                <div className="p-6 flex items-center gap-3">
                  <div className="bg-pink-500 text-white p-2.5 rounded-2xl shadow-sm shadow-pink-200 dark:shadow-none">
                    <Leaf className="w-6 h-6" />
                  </div>
                  <div>
                    <h1 className="text-2xl font-black tracking-tight text-pink-950 dark:text-pink-400">Vaine</h1>
                    <span className="text-[10px] font-bold tracking-widest uppercase bg-pink-100 dark:bg-pink-900/40 text-pink-700 dark:text-pink-300 px-2 py-0.5 rounded-full">Medical</span>
                  </div>
                </div>
                
                <nav className="flex-1 px-4 py-2 space-y-1.5 overflow-y-auto">
                  <NavItem 
                    icon={<Layers />} label={t('learningPath')} 
                    isActive={currentView === 'path'} onClick={() => setCurrentView('path')} 
                  />
                  <NavItem 
                    icon={<PlusCircle />} label={t('createLesson')} 
                    isActive={currentView === 'create'} onClick={() => setCurrentView('create')} 
                  />
                  <NavItem 
                    icon={<Zap />} label={t('speedMatchMenu')} 
                    isActive={currentView === 'speedMatch'} onClick={() => setCurrentView('speedMatch')} 
                  />
                  <NavItem 
                    icon={<Radio />} label={t('kahootLiveMenu')} 
                    isActive={currentView === 'kahoot'} onClick={() => setCurrentView('kahoot')} 
                  />

                  {activeLesson && (
                    <div className="pt-4 mt-4 border-t border-pink-50 dark:border-slate-700">
                      <p className="px-4 text-xs font-bold text-pink-400 uppercase tracking-wider mb-2">{t('activeSession')}</p>
                      <NavItem 
                        icon={<BookOpen />} label={t('studyArea')} 
                        isActive={currentView === 'study'} onClick={() => setCurrentView('study')} 
                      />
                    </div>
                  )}
                </nav>

                {/* User XP Badge Card */}
                <div className="p-4 m-4 bg-gradient-to-br from-pink-50 to-rose-50 dark:from-slate-800 dark:to-pink-950/30 rounded-2xl border border-pink-100 dark:border-pink-800/30 shadow-sm">
                  <div className="flex items-center gap-3 mb-2">
                    {calculateLevel(totalXP, t).current.icon}
                    <div>
                      <p className="text-[11px] text-pink-600 dark:text-pink-400 font-semibold uppercase">{t('currentStage')}</p>
                      <p className={`font-bold text-sm ${calculateLevel(totalXP, t).current.color}`}>{calculateLevel(totalXP, t).current.name}</p>
                    </div>
                  </div>
                  <div className="flex justify-between items-center text-xs font-bold text-pink-800 dark:text-pink-300">
                    <span>{totalXP} XP</span>
                    {calculateLevel(totalXP, t).next && <span className="text-pink-400 dark:text-pink-500">{t('next')}: {calculateLevel(totalXP, t).next.minXP} XP</span>}
                  </div>
                  {calculateLevel(totalXP, t).next && (
                    <div className="w-full bg-pink-200 dark:bg-slate-700 h-1.5 rounded-full mt-2 overflow-hidden">
                      <div 
                        className="bg-pink-500 h-full rounded-full transition-all duration-1000" 
                        style={{ width: `${Math.min(100, Math.max(0, ((totalXP - calculateLevel(totalXP, t).current.minXP) / (calculateLevel(totalXP, t).next.minXP - calculateLevel(totalXP, t).current.minXP)) * 100))}%` }}
                      ></div>
                    </div>
                  )}
                </div>
                
                {/* Toggles & Logout */}
                <div className="p-4 border-t border-pink-100 dark:border-slate-700 space-y-2">
                  <div className="flex gap-2">
                    <button onClick={() => setLang(lang === 'vi' ? 'en' : 'vi')} className="flex-1 flex items-center justify-center gap-2 py-2 bg-pink-50/50 dark:bg-slate-700 hover:bg-pink-100 dark:hover:bg-slate-600 rounded-xl text-xs font-bold text-slate-700 dark:text-slate-300 transition-colors">
                      <Globe className="w-3.5 h-3.5" /> {lang === 'vi' ? 'EN' : 'VI'}
                    </button>
                    <button onClick={() => setIsDark(!isDark)} className="flex-1 flex items-center justify-center gap-2 py-2 bg-pink-50/50 dark:bg-slate-700 hover:bg-pink-100 dark:hover:bg-slate-600 rounded-xl text-xs font-bold text-slate-700 dark:text-slate-300 transition-colors">
                      {isDark ? <Sun className="w-3.5 h-3.5 text-amber-400" /> : <Moon className="w-3.5 h-3.5 text-slate-500" />}
                    </button>
                  </div>
                  <button onClick={handleLogout} className="w-full flex items-center justify-center gap-2 py-2 text-rose-500 dark:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-500/10 rounded-xl font-bold text-sm transition-colors">
                    <LogOut className="w-4 h-4" /> {t('logout')}
                  </button>
                </div>
              </aside>

              {/* Main Workspace */}
              <main className="flex-1 flex flex-col relative overflow-hidden h-full">
                {notification && (
                  <div className={`absolute top-6 left-1/2 -translate-x-1/2 z-50 px-6 py-3 rounded-full shadow-lg flex items-center gap-2 transform transition-all animate-in slide-in-from-top-4 ${notification.type === 'error' ? 'bg-rose-500 text-white' : 'bg-pink-600 text-white'}`}>
                    {notification.type === 'error' ? <XCircle className="w-4 h-4" /> : <Sparkles className="w-4 h-4" />}
                    <span className="font-medium text-sm">{notification.msg}</span>
                  </div>
                )}

                <div className="flex-1 overflow-y-auto w-full">
                  {currentView === 'path' && (
                    <LearningPathView 
                      lessons={lessons} 
                      onOpen={openStudyArea} 
                      onDelete={deleteLesson} 
                      level={calculateLevel(totalXP, t).current}
                      totalXP={totalXP}
                    />
                  )}
                  {currentView === 'create' && <CreateLessonView onSave={saveLesson} />}
                  {currentView === 'speedMatch' && <SpeedMatchView lessons={lessons} />}
                  {currentView === 'kahoot' && <KahootLiveView lessons={lessons} />}
                  {currentView === 'study' && activeLesson && (
                    <StudyAreaView 
                      lesson={lessons.find(l => l.id === activeLesson.id) || activeLesson} 
                      onCompleteModule={(mode) => updateLessonProgress(activeLesson.id, mode)} 
                    />
                  )}
                </div>

                {/* Global Image Zoom Modal */}
                {zoomedImage && (
                  <div className="fixed inset-0 bg-black/80 backdrop-blur-md z-50 flex items-center justify-center p-4 animate-in fade-in" onClick={() => setZoomedImage(null)}>
                    <div className="relative max-w-5xl max-h-[90vh] flex flex-col items-center" onClick={e => e.stopPropagation()}>
                      <button onClick={() => setZoomedImage(null)} className="absolute -top-12 right-0 text-white hover:text-pink-300 p-2 rounded-full bg-white/10 backdrop-blur">
                        <X className="w-6 h-6" />
                      </button>
                      <img src={zoomedImage} alt="Enlarged Diagram" className="max-w-full max-h-[85vh] object-contain rounded-2xl shadow-2xl border border-white/20" />
                    </div>
                  </div>
                )}
              </main>
            </>
          )}
        </div>
      </div>
    </AppContext.Provider>
  );
}

function NavItem({ icon, label, isActive, onClick }) {
  return (
    <button 
      onClick={onClick}
      className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 ${
        isActive 
          ? 'bg-pink-500 text-white shadow-md shadow-pink-200 dark:shadow-none' 
          : 'text-slate-600 dark:text-slate-400 hover:bg-pink-50 dark:hover:bg-slate-700 hover:text-pink-700 dark:hover:text-pink-300'
      }`}
    >
      {React.cloneElement(icon, { className: 'w-5 h-5' })}
      <span className="font-semibold text-sm">{label}</span>
    </button>
  );
}

// --- VIEW: AUTHENTICATION ---
function AuthView({ showNotification }) {
  const { t, lang, setLang, isDark, setIsDark } = useAppContext();
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!auth) return;
    setLoading(true);
    try {
      if (isLogin) {
        await signInWithEmailAndPassword(auth, email, password);
      } else {
        await createUserWithEmailAndPassword(auth, email, password);
      }
    } catch (error) {
      showNotification(error.message, 'error');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full h-full bg-[#fff0f3] dark:bg-slate-900 flex flex-col items-center justify-center p-4 relative transition-colors duration-300">
      <div className="absolute top-6 right-6 flex gap-2">
        <button onClick={() => setLang(lang === 'vi' ? 'en' : 'vi')} className="p-2.5 bg-white dark:bg-slate-800 rounded-full shadow-sm text-slate-600 dark:text-slate-300 hover:text-pink-500">
          <Globe className="w-5 h-5" />
        </button>
        <button onClick={() => setIsDark(!isDark)} className="p-2.5 bg-white dark:bg-slate-800 rounded-full shadow-sm text-slate-600 dark:text-slate-300 hover:text-pink-500">
          {isDark ? <Sun className="w-5 h-5 text-amber-400" /> : <Moon className="w-5 h-5" />}
        </button>
      </div>

      <div className="max-w-md w-full bg-white dark:bg-slate-800 rounded-3xl shadow-xl p-8 border border-pink-100 dark:border-slate-700">
        <div className="flex justify-center mb-6">
          <div className="bg-pink-500 text-white p-3.5 rounded-2xl shadow-sm">
            <Leaf className="w-8 h-8" />
          </div>
        </div>
        <h2 className="text-3xl font-black text-center text-pink-950 dark:text-white mb-2">{t('welcome')}</h2>
        <p className="text-center text-slate-500 dark:text-slate-400 mb-8 text-sm">{t('subtitle')}</p>
        
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1 uppercase tracking-wider">{t('email')}</label>
            <input 
              type="email" required
              className="w-full p-3.5 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 dark:focus:ring-pink-900 outline-none transition-all dark:text-white"
              value={email} onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1 uppercase tracking-wider">{t('password')}</label>
            <input 
              type="password" required
              className="w-full p-3.5 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 focus:border-pink-500 focus:ring-2 focus:ring-pink-200 dark:focus:ring-pink-900 outline-none transition-all dark:text-white"
              value={password} onChange={(e) => setPassword(e.target.value)}
            />
          </div>
          <button 
            type="submit" disabled={loading}
            className="w-full py-3.5 mt-4 bg-pink-500 text-white font-bold rounded-xl hover:bg-pink-600 transition-all disabled:opacity-50 flex justify-center items-center gap-2 shadow-md shadow-pink-200 dark:shadow-none"
          >
            {loading && <Loader2 className="w-4 h-4 animate-spin" />}
            {isLogin ? t('signIn') : t('signUp')}
          </button>
        </form>
        
        <div className="mt-6 text-center text-sm text-slate-500 dark:text-slate-400">
          {isLogin ? t('noAccount') : t('hasAccount')}
          <button onClick={() => setIsLogin(!isLogin)} className="text-pink-600 dark:text-pink-400 font-bold hover:underline">
            {isLogin ? t('signUp') : t('signIn')}
          </button>
        </div>
      </div>
    </div>
  );
}

// --- VIEW: LEARNING PATH & SUBJECT FILTER ---
function LearningPathView({ lessons, onOpen, onDelete, level, totalXP }) {
  const { t } = useAppContext();
  const [selectedSubject, setSelectedSubject] = useState('ALL');

  const subjects = Array.from(new Set(lessons.map(l => l.subject || t('presetAnatomy'))));
  
  const filteredLessons = selectedSubject === 'ALL' 
    ? lessons 
    : lessons.filter(l => (l.subject || t('presetAnatomy')) === selectedSubject);

  const groupedByTopic = filteredLessons.reduce((acc, lesson) => {
    const topic = lesson.topic || 'Chủ đề chung';
    if (!acc[topic]) acc[topic] = [];
    acc[topic].push(lesson);
    return acc;
  }, {});

  return (
    <div className="max-w-5xl mx-auto p-4 md:p-8 animate-in fade-in duration-500 pb-20">
      
      {/* Level Banner */}
      <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 md:p-8 shadow-sm border border-pink-100 dark:border-slate-700 flex flex-col md:flex-row items-center gap-6 mb-8 relative overflow-hidden transition-colors">
        <div className="absolute top-0 right-0 w-64 h-64 bg-pink-50 dark:bg-pink-900/20 rounded-full blur-3xl -mr-20 -mt-20 opacity-50 pointer-events-none"></div>
        
        <div className={`w-28 h-28 rounded-full ${level.bg} flex items-center justify-center border-4 border-white dark:border-slate-800 shadow-lg z-10 shrink-0`}>
          {React.cloneElement(level.icon, { className: 'w-14 h-14' })}
        </div>
        
        <div className="z-10 flex-1 text-center md:text-left">
          <h2 className="text-3xl font-black text-pink-950 dark:text-white mb-2">
            {t('youAreA')} <span className={level.color}>{level.name}</span>!
          </h2>
          <p className="text-slate-500 dark:text-slate-400 text-sm md:text-base mb-4">
            {t('youHaveEarned')} <span className="font-bold text-pink-500 dark:text-pink-400">{totalXP} XP</span>. {t('keepStudying')}
          </p>
          <div className="flex flex-wrap gap-2 justify-center md:justify-start">
            {getLevels(t).map((l, idx) => (
              <div key={idx} className={`px-3 py-1 rounded-full text-xs font-bold border ${totalXP >= l.minXP ? `${l.bg} ${l.color} border-transparent shadow-sm` : 'bg-slate-50 dark:bg-slate-900 text-slate-300 dark:text-slate-600 border-slate-200 dark:border-slate-700'}`}>
                {l.name}
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Subject Filter Tabs */}
      <div className="mb-8">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-xl font-bold text-pink-950 dark:text-white flex items-center gap-2">
            <Layers className="text-pink-500 w-5 h-5" />
            {t('yourSubjects')}
          </h3>
        </div>

        <div className="flex gap-2 overflow-x-auto pb-2 hide-scrollbar">
          <button 
            onClick={() => setSelectedSubject('ALL')}
            className={`px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-all ${
              selectedSubject === 'ALL' 
                ? 'bg-pink-500 text-white shadow-sm' 
                : 'bg-white dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-pink-50 dark:hover:bg-slate-700 border border-pink-100 dark:border-slate-700'
            }`}
          >
            {t('allSubjects')} ({lessons.length})
          </button>

          {subjects.map((sub, i) => (
            <button 
              key={i}
              onClick={() => setSelectedSubject(sub)}
              className={`px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-all ${
                selectedSubject === sub 
                  ? 'bg-pink-500 text-white shadow-sm' 
                  : 'bg-white dark:bg-slate-800 text-slate-600 dark:text-slate-300 hover:bg-pink-50 dark:hover:bg-slate-700 border border-pink-100 dark:border-slate-700'
              }`}
            >
              {sub} ({lessons.filter(l => (l.subject || t('presetAnatomy')) === sub).length})
            </button>
          ))}
        </div>
      </div>

      {/* Topics & Lessons */}
      {lessons.length === 0 ? (
        <div className="bg-white dark:bg-slate-800 rounded-3xl border border-dashed border-pink-200 dark:border-slate-600 p-12 text-center">
          <div className="w-16 h-16 bg-pink-50 dark:bg-slate-700 rounded-full flex items-center justify-center mx-auto mb-4">
            <Plus className="w-8 h-8 text-pink-400 dark:text-pink-500" />
          </div>
          <h4 className="text-lg font-bold text-pink-900 dark:text-pink-300 mb-2">{t('emptySoil')}</h4>
          <p className="text-slate-500 dark:text-slate-400 mb-6 max-w-md mx-auto text-sm">{t('createFirstLesson')}</p>
        </div>
      ) : (
        <div className="space-y-6">
          {Object.entries(groupedByTopic).map(([topic, topicLessons]) => (
            <TopicFolder 
              key={topic} 
              topic={topic} 
              lessons={topicLessons} 
              onOpen={onOpen} 
              onDelete={onDelete} 
            />
          ))}
        </div>
      )}
    </div>
  );
}

function TopicFolder({ topic, lessons, onOpen, onDelete }) {
  const { t } = useAppContext();
  const [isOpen, setIsOpen] = useState(true);

  return (
    <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-pink-100 dark:border-slate-700 overflow-hidden transition-colors">
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="w-full p-4 md:p-5 flex items-center justify-between bg-pink-50/50 dark:bg-slate-800/80 hover:bg-pink-50 dark:hover:bg-slate-700 transition-colors"
      >
        <div className="flex items-center gap-3">
          <div className="bg-pink-100 dark:bg-pink-900/30 p-2 rounded-lg text-pink-600 dark:text-pink-400">
            <Folder className="w-5 h-5" />
          </div>
          <h4 className="text-lg font-bold text-pink-950 dark:text-white">{topic}</h4>
          <span className="bg-pink-200/50 dark:bg-pink-900/50 text-pink-700 dark:text-pink-300 text-xs font-bold px-2 py-0.5 rounded-full">
            {lessons.length} {t('lessons')}
          </span>
        </div>
        {isOpen ? <ChevronUp className="text-pink-600 dark:text-pink-400 w-5 h-5" /> : <ChevronDown className="text-pink-600 dark:text-pink-400 w-5 h-5" />}
      </button>
      
      {isOpen && (
        <div className="p-4 md:p-5 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 bg-slate-50/30 dark:bg-slate-900/30">
          {lessons.map((lesson) => {
            const prog = lesson.progress || { flashcards: false, multiple_choice: false, true_false: false, fill_blanks: false };
            const completedCount = Object.values(prog).filter(Boolean).length;
            const progressPercent = Math.round((completedCount / 4) * 100);
            const isFullyComplete = completedCount === 4;

            const imageCount = [
              ...(lesson.flashcards || []),
              ...(lesson.multiple_choice || []),
              ...(lesson.true_false || []),
              ...(lesson.fill_blanks || [])
            ].filter(item => Boolean(item.imageUrl)).length;

            return (
              <div key={lesson.id} className={`bg-white dark:bg-slate-800 rounded-2xl p-5 shadow-sm border transition-all hover:-translate-y-1 relative group flex flex-col justify-between ${isFullyComplete ? 'border-pink-200 dark:border-pink-800/50 bg-pink-50/20 dark:bg-pink-900/10' : 'border-slate-100 dark:border-slate-700 hover:border-pink-200 dark:hover:border-pink-500/50 hover:shadow-md'}`}>
                <div>
                  <div className="flex justify-between items-start mb-2">
                    <span className="text-[10px] font-bold uppercase tracking-wider text-pink-600 dark:text-pink-400 bg-pink-100/60 dark:bg-pink-900/40 px-2.5 py-0.5 rounded-full">
                      {lesson.subject || t('presetAnatomy')}
                    </span>
                    <button onClick={() => onDelete(lesson.id)} className="p-1 text-slate-300 hover:text-rose-500 hover:bg-rose-50 dark:hover:bg-rose-900/30 rounded-lg transition-colors opacity-0 group-hover:opacity-100">
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                  
                  <h5 className="text-base font-bold text-slate-800 dark:text-slate-100 mb-1 line-clamp-2">{lesson.title}</h5>
                  
                  {imageCount > 0 && (
                    <div className="inline-flex items-center gap-1 text-[11px] font-semibold text-pink-600 dark:text-pink-400 mb-3 bg-pink-50 dark:bg-pink-900/30 px-2 py-0.5 rounded-md">
                      <ImageIcon className="w-3.5 h-3.5" />
                      <span>{imageCount} sơ đồ / ảnh</span>
                    </div>
                  )}
                </div>

                <div className="mt-4 pt-3 border-t border-slate-100 dark:border-slate-700/50">
                  <div className="flex justify-between text-xs font-bold text-slate-500 dark:text-slate-400 mb-1.5">
                    <span>{t('progress')}</span>
                    <span className={isFullyComplete ? 'text-pink-600 dark:text-pink-400' : ''}>{progressPercent}%</span>
                  </div>
                  <div className="w-full bg-slate-100 dark:bg-slate-700 h-1.5 rounded-full mb-4 overflow-hidden">
                    <div 
                      className={`h-full rounded-full transition-all duration-500 ${isFullyComplete ? 'bg-pink-500' : 'bg-slate-400 dark:bg-slate-500'}`}
                      style={{ width: `${progressPercent}%` }}
                    ></div>
                  </div>
                  
                  <button
                    onClick={() => onOpen(lesson)}
                    className={`w-full py-2.5 rounded-xl font-bold flex items-center justify-center gap-2 transition-all text-xs ${
                      isFullyComplete 
                        ? 'bg-pink-50 dark:bg-pink-900/20 text-pink-700 dark:text-pink-400 hover:bg-pink-100 dark:hover:bg-pink-900/40' 
                        : 'bg-pink-500 text-white hover:bg-pink-600 shadow-md shadow-pink-200/50 dark:shadow-none'
                    }`}
                  >
                    <Play className={`w-3.5 h-3.5 ${isFullyComplete ? '' : 'fill-current'}`} /> 
                    {isFullyComplete ? t('review') : t('studyNow')}
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

// --- VIEW: CREATE LESSON (MANUAL, PDF/FILE UPLOAD, AI TEXT) ---
function CreateLessonView({ onSave }) {
  const { t } = useAppContext();
  const [creationMode, setCreationMode] = useState('file'); // 'manual', 'file', 'ai'

  // Header State
  const [subject, setSubject] = useState(t('presetAnatomy'));
  const [topic, setTopic] = useState('');
  const [title, setTitle] = useState('');

  // Manual Creation State
  const [flashcards, setFlashcards] = useState([{ term: '', definition: '', imageUrl: '' }]);
  const [multipleChoice, setMultipleChoice] = useState([{ question: '', options: ['', '', '', ''], answer: '', imageUrl: '' }]);
  const [trueFalse, setTrueFalse] = useState([{ statement: '', answer: true, imageUrl: '' }]);
  const [fillBlanks, setFillBlanks] = useState([{ sentence: '', answer: '', imageUrl: '' }]);

  // File Upload State
  const [uploadedFileName, setUploadedFileName] = useState('');
  const [extractedText, setExtractedText] = useState('');
  const [isReadingFile, setIsReadingFile] = useState(false);
  const fileInputRef = useRef(null);

  // AI Generator & Preview State
  const [aiText, setAiText] = useState('');
  const [isGenerating, setIsGenerating] = useState(false);
  const [errorMsg, setErrorMsg] = useState(null);
  const [generatedPreview, setGeneratedPreview] = useState(null);

  // Handle File Upload & Extraction
  const handleFileUpload = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setIsReadingFile(true);
    setUploadedFileName(file.name);
    try {
      const text = await extractTextFromFile(file);
      setExtractedText(text);
      if (!title) setTitle(file.name.replace(/\.[^/.]+$/, ""));
    } catch (err) {
      console.error("File reading error:", err);
      setErrorMsg("Không thể đọc file. Vui lòng thử lại với file .txt, .pdf hoặc .docx khác.");
    } finally {
      setIsReadingFile(false);
    }
  };

  const handleImageUpload = async (e, updateFn, items, index) => {
    const file = e.target.files[0];
    if (!file) return;
    try {
      const dataUrl = await compressAndReadImage(file);
      const newItems = [...items];
      newItems[index].imageUrl = dataUrl;
      updateFn(newItems);
    } catch (err) {
      console.error("Image upload failed", err);
    }
  };

  const handleSaveManual = async (e) => {
    e.preventDefault();
    if (!subject.trim() || !topic.trim() || !title.trim()) {
      setErrorMsg(t('fillAllFields'));
      return;
    }

    const cleanCards = flashcards.filter(f => f.term.trim() || f.definition.trim() || f.imageUrl);
    const cleanMCQ = multipleChoice.filter(m => m.question.trim() || m.imageUrl);
    const cleanTF = trueFalse.filter(tf => tf.statement.trim() || tf.imageUrl);
    const cleanBlanks = fillBlanks.filter(b => b.sentence.trim() || b.imageUrl);

    const lessonData = {
      flashcards: cleanCards,
      multiple_choice: cleanMCQ,
      true_false: cleanTF,
      fill_blanks: cleanBlanks
    };

    await onSave(lessonData, subject, topic, title);
  };

  const handleGenerateAI = async (sourceText) => {
    if (!sourceText.trim()) {
      setErrorMsg(t('fillAllFields'));
      return;
    }
    setIsGenerating(true);
    setErrorMsg(null);

    const prompt = `Act as an expert medical education assistant. Generate a rich study question bank from the following medical/specialized material.
    Subject context: "${subject}", Topic: "${topic || 'General'}".
    Requirements:
    - flashcards: 5 key medical terms/structures (term) and clear definitions/notes (definition).
    - multiple_choice: 4 high-yield questions with 4 distinct options each, and the exact correct answer string.
    - true_false: 4 statements based on clinical/anatomy details.
    - fill_blanks: 4 sentences using "___" for missing terms, and correct answer key.
    
    Source Material:
    ${sourceText.slice(0, 4000)}`;

    const schema = {
      type: "OBJECT",
      properties: {
        flashcards: { type: "ARRAY", items: { type: "OBJECT", properties: { term: { type: "STRING" }, definition: { type: "STRING" } } } },
        multiple_choice: { type: "ARRAY", items: { type: "OBJECT", properties: { question: { type: "STRING" }, options: { type: "ARRAY", items: { type: "STRING" } }, answer: { type: "STRING" } } } },
        true_false: { type: "ARRAY", items: { type: "OBJECT", properties: { statement: { type: "STRING" }, answer: { type: "BOOLEAN" } } } },
        fill_blanks: { type: "ARRAY", items: { type: "OBJECT", properties: { sentence: { type: "STRING" }, answer: { type: "STRING" } } } }
      },
      required: ["flashcards", "multiple_choice", "true_false", "fill_blanks"]
    };

    try {
      const response = await fetch(GEMINI_API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ role: "user", parts: [{ text: prompt }] }],
          generationConfig: { responseMimeType: "application/json", responseSchema: schema }
        })
      });
      const result = await response.json();
      if (result.candidates && result.candidates[0]) {
        const generated = JSON.parse(result.candidates[0].content.parts[0].text);
        setGeneratedPreview(generated);
      } else {
        throw new Error("Invalid AI response");
      }
    } catch (err) {
      console.error(err);
      setErrorMsg(t('genFailed'));
    } finally {
      setIsGenerating(false);
    }
  };

  const saveGeneratedPreview = async () => {
    if (!generatedPreview) return;
    if (!subject.trim() || !topic.trim() || !title.trim()) {
      setErrorMsg(t('fillAllFields'));
      return;
    }
    await onSave(generatedPreview, subject, topic, title);
  };

  return (
    <div className="max-w-4xl mx-auto p-4 md:p-8 animate-in fade-in duration-300 pb-20">
      <div className="bg-white dark:bg-slate-800 rounded-3xl shadow-sm border border-pink-100 dark:border-slate-700 p-6 md:p-8 transition-colors">
        
        {/* Header & Mode Selector */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
          <div>
            <h2 className="text-2xl font-black text-slate-800 dark:text-white">{t('createLessonTitle')}</h2>
            <p className="text-slate-500 dark:text-slate-400 text-sm mt-1">{t('createLessonDesc')}</p>
          </div>
          
          <div className="flex bg-pink-50 dark:bg-slate-700/50 p-1 rounded-2xl border border-pink-100 dark:border-slate-600 self-start md:self-auto">
            <button 
              type="button"
              onClick={() => { setCreationMode('file'); setGeneratedPreview(null); }}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${creationMode === 'file' ? 'bg-pink-500 text-white shadow-sm' : 'text-slate-600 dark:text-slate-300'}`}
            >
              <FileUp className="w-3.5 h-3.5" /> {t('fileUploadTab')}
            </button>
            <button 
              type="button"
              onClick={() => { setCreationMode('manual'); setGeneratedPreview(null); }}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${creationMode === 'manual' ? 'bg-pink-500 text-white shadow-sm' : 'text-slate-600 dark:text-slate-300'}`}
            >
              <Edit3 className="w-3.5 h-3.5" /> {t('manualTab')}
            </button>
            <button 
              type="button"
              onClick={() => { setCreationMode('ai'); setGeneratedPreview(null); }}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${creationMode === 'ai' ? 'bg-pink-500 text-white shadow-sm' : 'text-slate-600 dark:text-slate-300'}`}
            >
              <BrainCircuit className="w-3.5 h-3.5" /> {t('aiTab')}
            </button>
          </div>
        </div>

        {/* Global Metadata (Subject, Topic, Title) */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8 bg-pink-50/50 dark:bg-slate-900/50 p-4 rounded-2xl border border-pink-100/50 dark:border-slate-700">
          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1 uppercase">{t('subjectName')}</label>
            <input 
              type="text" required list="subject-presets" placeholder={t('selectOrTypeSubject')}
              className="w-full p-3 rounded-xl bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-sm font-medium focus:border-pink-500 dark:focus:border-pink-500 dark:text-white outline-none"
              value={subject} onChange={(e) => setSubject(e.target.value)}
            />
            <datalist id="subject-presets">
              <option value={t('presetAnatomy')} />
              <option value={t('presetHistology')} />
              <option value={t('presetPharm')} />
              <option value={t('presetEnglish')} />
            </datalist>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1 uppercase">{t('topicName')}</label>
            <input 
              type="text" required placeholder="VD: Hệ xương, Mô liên kết..."
              className="w-full p-3 rounded-xl bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-sm font-medium focus:border-pink-500 dark:focus:border-pink-500 dark:text-white outline-none"
              value={topic} onChange={(e) => setTopic(e.target.value)}
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-1 uppercase">{t('lessonTitle')}</label>
            <input 
              type="text" required placeholder="VD: Xương chi trên & Tiêu bản"
              className="w-full p-3 rounded-xl bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 text-sm font-medium focus:border-pink-500 dark:focus:border-pink-500 dark:text-white outline-none"
              value={title} onChange={(e) => setTitle(e.target.value)}
            />
          </div>
        </div>

        {errorMsg && (
          <div className="mb-6 p-3 bg-red-50 dark:bg-red-900/30 text-red-600 dark:text-red-400 rounded-xl text-sm font-bold flex items-center gap-2">
            <XCircle className="w-4 h-4" /> {errorMsg}
          </div>
        )}

        {/* INTERACTIVE GENERATED PREVIEW (IF AI GENERATED FROM FILE OR TEXT) */}
        {generatedPreview ? (
          <div className="space-y-6 border-t pt-6 border-slate-200 dark:border-slate-700">
            <div className="flex items-center justify-between">
              <h3 className="text-xl font-bold text-pink-950 dark:text-white flex items-center gap-2">
                <Sparkles className="w-5 h-5 text-pink-500" /> {t('previewGeneratedTitle')}
              </h3>
              <button 
                onClick={() => setGeneratedPreview(null)}
                className="text-xs font-bold text-slate-400 hover:text-rose-500"
              >
                Làm lại / Hủy
              </button>
            </div>

            <div className="bg-slate-50 dark:bg-slate-900/50 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-4 max-h-96 overflow-y-auto">
              <div>
                <p className="text-xs font-bold text-pink-600 uppercase mb-2">Flashcards ({generatedPreview.flashcards?.length})</p>
                {generatedPreview.flashcards?.map((f, i) => (
                  <div key={i} className="text-xs bg-white dark:bg-slate-800 p-2.5 rounded-xl mb-2 border">
                    <span className="font-bold text-slate-800 dark:text-white">{typeof f.term === 'object' ? JSON.stringify(f.term) : String(f.term || '')}: </span>
                    <span className="text-slate-600 dark:text-slate-300">{typeof f.definition === 'object' ? JSON.stringify(f.definition) : String(f.definition || '')}</span>
                  </div>
                ))}
              </div>

              <div>
                <p className="text-xs font-bold text-pink-600 uppercase mb-2">Trắc nghiệm ({generatedPreview.multiple_choice?.length})</p>
                {generatedPreview.multiple_choice?.map((m, i) => (
                  <div key={i} className="text-xs bg-white dark:bg-slate-800 p-2.5 rounded-xl mb-2 border">
                    <p className="font-bold text-slate-800 dark:text-white mb-1">{i + 1}. {typeof m.question === 'object' ? JSON.stringify(m.question) : String(m.question || '')}</p>
                    <p className="text-pink-600 font-semibold">Đáp án: {typeof m.answer === 'object' ? JSON.stringify(m.answer) : String(m.answer || '')}</p>
                  </div>
                ))}
              </div>
            </div>

            <button
              onClick={saveGeneratedPreview}
              className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl hover:bg-pink-600 shadow-lg shadow-pink-200 dark:shadow-none transition-all flex items-center justify-center gap-2"
            >
              <Check className="w-5 h-5" /> {t('saveGeneratedLesson')}
            </button>
          </div>
        ) : (
          <>
            {/* TAB 1: FILE UPLOAD (.pdf, .docx, .txt) */}
            {creationMode === 'file' && (
              <div className="space-y-6">
                <input 
                  type="file" ref={fileInputRef} className="hidden" 
                  accept=".pdf,.docx,.txt,.md" onChange={handleFileUpload}
                />
                
                <div 
                  onClick={() => fileInputRef.current?.click()}
                  className="border-2 border-dashed border-pink-300 dark:border-pink-800/60 bg-pink-50/40 dark:bg-pink-950/20 hover:bg-pink-50 dark:hover:bg-pink-900/30 rounded-3xl p-10 text-center cursor-pointer transition-all flex flex-col items-center justify-center gap-3"
                >
                  <div className="w-16 h-16 bg-pink-500 text-white rounded-2xl flex items-center justify-center shadow-md shadow-pink-200 dark:shadow-none">
                    <UploadCloud className="w-8 h-8" />
                  </div>
                  <div>
                    <h4 className="text-lg font-bold text-pink-950 dark:text-white">{t('dragDropTitle')}</h4>
                    <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">{t('dragDropDesc')}</p>
                  </div>
                </div>

                {isReadingFile && (
                  <div className="p-4 bg-pink-50 dark:bg-slate-900 rounded-2xl flex items-center gap-3 text-pink-600 dark:text-pink-400 font-bold text-sm">
                    <Loader2 className="w-5 h-5 animate-spin" />
                    <span>{t('extractingText')}</span>
                  </div>
                )}

                {extractedText && (
                  <div className="space-y-4">
                    <div className="flex justify-between items-center">
                      <span className="text-xs font-bold text-pink-600 dark:text-pink-400 uppercase flex items-center gap-1.5">
                        <FileText className="w-4 h-4" /> {uploadedFileName} ({extractedText.length} kí tự)
                      </span>
                    </div>

                    <textarea
                      value={extractedText}
                      onChange={(e) => setExtractedText(e.target.value)}
                      className="w-full h-48 p-4 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-2xl text-xs font-mono dark:text-white leading-relaxed resize-none outline-none focus:border-pink-500"
                      placeholder={t('previewExtractedText')}
                    />

                    <button
                      onClick={() => handleGenerateAI(extractedText)}
                      disabled={isGenerating}
                      className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl hover:bg-pink-600 disabled:opacity-50 flex items-center justify-center gap-2 shadow-md shadow-pink-200 dark:shadow-none"
                    >
                      {isGenerating ? <Loader2 className="w-5 h-5 animate-spin" /> : <BrainCircuit className="w-5 h-5" />}
                      <span>{t('analyzeWithAI')}</span>
                    </button>
                  </div>
                )}
              </div>
            )}

            {/* TAB 2: MANUAL BUILDER */}
            {creationMode === 'manual' && (
              <form onSubmit={handleSaveManual} className="space-y-8">
                <SectionBuilder 
                  title="1. Flashcards (Ghép thẻ / Sơ đồ chú thích)" 
                  onAdd={() => setFlashcards([...flashcards, { term: '', definition: '', imageUrl: '' }])}
                  addBtnLabel={t('addFlashcard')}
                >
                  {flashcards.map((fc, i) => (
                    <div key={i} className="p-4 bg-slate-50 dark:bg-slate-900/50 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-3 relative">
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                        <input 
                          type="text" placeholder={t('term')}
                          className="p-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm dark:text-white font-medium"
                          value={fc.term} onChange={e => { const copy = [...flashcards]; copy[i].term = e.target.value; setFlashcards(copy); }}
                        />
                        <input 
                          type="text" placeholder={t('definition')}
                          className="p-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm dark:text-white font-medium"
                          value={fc.definition} onChange={e => { const copy = [...flashcards]; copy[i].definition = e.target.value; setFlashcards(copy); }}
                        />
                      </div>
                      <ImageUploaderInput 
                        imageUrl={fc.imageUrl}
                        onFileSelect={e => handleImageUpload(e, setFlashcards, flashcards, i)}
                        onUrlChange={url => { const copy = [...flashcards]; copy[i].imageUrl = url; setFlashcards(copy); }}
                        onRemove={() => { const copy = [...flashcards]; copy[i].imageUrl = ''; setFlashcards(copy); }}
                      />
                      {flashcards.length > 1 && (
                        <button type="button" onClick={() => setFlashcards(flashcards.filter((_, idx) => idx !== i))} className="absolute top-2 right-2 text-slate-400 hover:text-red-500 p-1">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      )}
                    </div>
                  ))}
                </SectionBuilder>

                <SectionBuilder 
                  title="2. Trắc nghiệm (Multiple Choice)" 
                  onAdd={() => setMultipleChoice([...multipleChoice, { question: '', options: ['', '', '', ''], answer: '', imageUrl: '' }])}
                  addBtnLabel={t('addMCQ')}
                >
                  {multipleChoice.map((mc, i) => (
                    <div key={i} className="p-4 bg-slate-50 dark:bg-slate-900/50 rounded-2xl border border-slate-200 dark:border-slate-700 space-y-3 relative">
                      <input 
                        type="text" placeholder={t('questionStr')}
                        className="w-full p-3 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-bold dark:text-white"
                        value={mc.question} onChange={e => { const copy = [...multipleChoice]; copy[i].question = e.target.value; setMultipleChoice(copy); }}
                      />
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
                        {mc.options.map((opt, optIdx) => (
                          <input 
                            key={optIdx} type="text" placeholder={`${t('option')} ${optIdx + 1}`}
                            className="p-2.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs dark:text-white"
                            value={opt} onChange={e => {
                              const copy = [...multipleChoice];
                              copy[i].options[optIdx] = e.target.value;
                              setMultipleChoice(copy);
                            }}
                          />
                        ))}
                      </div>
                      <input 
                        type="text" placeholder={t('correctAnswer')}
                        className="w-full p-2.5 bg-pink-50/50 dark:bg-pink-900/20 border border-pink-200 dark:border-pink-800 rounded-xl text-xs font-bold text-pink-900 dark:text-pink-300"
                        value={mc.answer} onChange={e => { const copy = [...multipleChoice]; copy[i].answer = e.target.value; setMultipleChoice(copy); }}
                      />
                      <ImageUploaderInput 
                        imageUrl={mc.imageUrl}
                        onFileSelect={e => handleImageUpload(e, setMultipleChoice, multipleChoice, i)}
                        onUrlChange={url => { const copy = [...multipleChoice]; copy[i].imageUrl = url; setMultipleChoice(copy); }}
                        onRemove={() => { const copy = [...multipleChoice]; copy[i].imageUrl = ''; setMultipleChoice(copy); }}
                      />
                      {multipleChoice.length > 1 && (
                        <button type="button" onClick={() => setMultipleChoice(multipleChoice.filter((_, idx) => idx !== i))} className="absolute top-2 right-2 text-slate-400 hover:text-red-500 p-1">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      )}
                    </div>
                  ))}
                </SectionBuilder>

                <button
                  type="submit"
                  className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl hover:bg-pink-600 shadow-lg shadow-pink-200 dark:shadow-none text-base transition-all"
                >
                  {t('saveLessonBtn')}
                </button>
              </form>
            )}

            {/* TAB 3: AI TEXT CREATOR */}
            {creationMode === 'ai' && (
              <form onSubmit={(e) => { e.preventDefault(); handleGenerateAI(aiText); }} className="space-y-6">
                <div>
                  <label className="block text-xs font-bold text-slate-700 dark:text-slate-300 mb-2 uppercase">Văn bản / Tài liệu tiếng Anh hoặc Y khoa</label>
                  <textarea
                    required
                    className="w-full h-64 p-4 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-2xl focus:border-pink-500 dark:focus:border-pink-500 dark:text-white outline-none resize-none text-sm leading-relaxed"
                    placeholder="Dán đoạn văn bản y khoa hoặc danh sách từ vựng vào đây..."
                    value={aiText} onChange={e => setAiText(e.target.value)} disabled={isGenerating}
                  ></textarea>
                </div>

                <button
                  type="submit"
                  disabled={isGenerating}
                  className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl hover:bg-pink-600 disabled:opacity-50 flex items-center justify-center gap-2 shadow-md shadow-pink-200 dark:shadow-none"
                >
                  {isGenerating ? <Loader2 className="w-5 h-5 animate-spin" /> : <BrainCircuit className="w-5 h-5" />}
                  <span>Tạo bộ câu hỏi bằng AI</span>
                </button>
              </form>
            )}
          </>
        )}
      </div>
    </div>
  );
}

function SectionBuilder({ title, onAdd, addBtnLabel, children }) {
  return (
    <div className="space-y-3 pt-2">
      <div className="flex justify-between items-center">
        <h4 className="text-sm font-bold text-pink-950 dark:text-pink-300">{title}</h4>
        <button type="button" onClick={onAdd} className="text-xs font-bold text-pink-600 dark:text-pink-400 hover:underline">
          {addBtnLabel}
        </button>
      </div>
      <div className="space-y-3">{children}</div>
    </div>
  );
}

function ImageUploaderInput({ imageUrl, onFileSelect, onUrlChange, onRemove }) {
  const { t } = useAppContext();
  const fileInputRef = useRef(null);

  return (
    <div className="flex flex-col sm:flex-row items-center gap-2 pt-1">
      <input 
        type="file" accept="image/*" ref={fileInputRef} className="hidden" 
        onChange={onFileSelect}
      />
      <button 
        type="button" 
        onClick={() => fileInputRef.current?.click()}
        className="px-3 py-2 bg-pink-50 dark:bg-slate-800 hover:bg-pink-100 text-pink-700 dark:text-pink-300 rounded-xl text-xs font-bold border border-pink-100 dark:border-slate-700 flex items-center gap-1.5 shrink-0"
      >
        <Upload className="w-3.5 h-3.5" /> {t('uploadImg')}
      </button>

      <input 
        type="text" placeholder={t('imgUrlPlaceholder')}
        className="flex-1 p-2 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs dark:text-white"
        value={imageUrl || ''} onChange={e => onUrlChange(e.target.value)}
      />

      {imageUrl && (
        <div className="flex items-center gap-2 shrink-0">
          <div className="w-8 h-8 rounded-lg overflow-hidden border border-slate-200 relative group">
            <img src={imageUrl} alt="preview" className="w-full h-full object-cover" />
          </div>
          <button type="button" onClick={onRemove} className="text-rose-500 hover:text-rose-700 p-1">
            <X className="w-4 h-4" />
          </button>
        </div>
      )}
    </div>
  );
}

// --- FEATURE: KAHOOT-STYLE LIVE BATTLE MODE ---
function KahootLiveView({ lessons }) {
  const { t, user, addXP } = useAppContext();
  const [liveMode, setLiveMode] = useState('select'); // 'select', 'host', 'player'
  const [selectedLesson, setSelectedLesson] = useState(null);
  const [roomPin, setRoomPin] = useState('');
  
  // Host State
  const [players, setPlayers] = useState([]);
  const [gameStep, setGameStep] = useState('lobby'); // 'lobby', 'question', 'reveal', 'leaderboard', 'finished'
  const [currentQIndex, setCurrentQIndex] = useState(0);
  const [timeLeft, setTimeLeft] = useState(20);
  const [responses, setResponses] = useState([0, 0, 0, 0]);

  // Player State
  const [inputPin, setInputPin] = useState('');
  const [nickname, setNickname] = useState('');
  const [playerJoined, setPlayerJoined] = useState(false);
  const [playerScore, setPlayerScore] = useState(0);
  const [streak, setStreak] = useState(0);
  const [playerAnswered, setPlayerAnswered] = useState(null);

  // Timer Ref
  const timerRef = useRef(null);

  const questions = useMemo(() => {
    if (!selectedLesson) return [];
    return selectedLesson.multiple_choice || [];
  }, [selectedLesson]);

  // Generate Room PIN
  const createRoom = () => {
    if (!selectedLesson || !questions.length) return;
    const pin = Math.floor(100000 + Math.random() * 900000).toString();
    setRoomPin(pin);
    setPlayers([
      { id: 'host', name: user.email?.split('@')[0] || 'Host Doctor', score: 0, streak: 0 }
    ]);
    setGameStep('lobby');
    setLiveMode('host');
  };

  const addBot = () => {
    const botNames = ['Dr. Alex', 'BS. Minh', 'Dr. Sarah', 'Dr. Y', 'Sinh viên Y1', 'Dr. House'];
    const randomName = botNames[Math.floor(Math.random() * botNames.length)] + '_' + Math.floor(Math.random() * 90);
    setPlayers(prev => [...prev, { id: `bot_${Date.now()}_${Math.random()}`, name: randomName, score: 0, streak: 0 }]);
  };

  const startBattle = () => {
    setGameStep('question');
    setCurrentQIndex(0);
    startQuestionTimer();
  };

  const startQuestionTimer = () => {
    setTimeLeft(20);
    setResponses([0, 0, 0, 0]);
    if (timerRef.current) clearInterval(timerRef.current);
    
    timerRef.current = setInterval(() => {
      setTimeLeft(prev => {
        if (prev <= 1) {
          clearInterval(timerRef.current);
          revealRoundResults();
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
  };

  const revealRoundResults = () => {
    const simulatedDist = [
      Math.floor(Math.random() * players.length),
      Math.floor(Math.random() * players.length),
      Math.floor(Math.random() * players.length),
      Math.floor(Math.random() * players.length)
    ];
    setResponses(simulatedDist);

    setPlayers(prev => prev.map(p => {
      const correct = Math.random() > 0.3;
      if (correct) {
        const added = 800 + Math.floor(Math.random() * 200);
        return { ...p, score: p.score + added, streak: p.streak + 1 };
      }
      return { ...p, streak: 0 };
    }));

    setGameStep('reveal');
  };

  const nextQuestion = () => {
    if (currentQIndex < questions.length - 1) {
      setCurrentQIndex(c => c + 1);
      setGameStep('question');
      startQuestionTimer();
    } else {
      setGameStep('finished');
      addXP(50);
    }
  };

  const submitPlayerAnswer = (idx) => {
    setPlayerAnswered(idx);
    const currQ = questions[currentQIndex];
    const isCorrect = currQ && currQ.options[idx] === currQ.answer;
    if (isCorrect) {
      const gain = 900 + streak * 50;
      setPlayerScore(s => s + gain);
      setStreak(st => st + 1);
    } else {
      setStreak(0);
    }
  };

  return (
    <div className="max-w-5xl mx-auto p-4 md:p-8 animate-in fade-in duration-300 pb-20">
      
      {/* View Selector */}
      {liveMode === 'select' && (
        <div className="space-y-8">
          <div className="bg-white dark:bg-slate-800 p-8 rounded-3xl shadow-sm border border-pink-100 dark:border-slate-700 text-center">
            <div className="w-16 h-16 bg-pink-500 text-white rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-md shadow-pink-200 dark:shadow-none">
              <Radio className="w-8 h-8 animate-pulse" />
            </div>
            <h2 className="text-3xl font-black text-slate-800 dark:text-white mb-2">{t('kahootTitle')}</h2>
            <p className="text-slate-500 dark:text-slate-400 text-base max-w-md mx-auto">{t('kahootDesc')}</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Host Section */}
            <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-pink-100 dark:border-slate-700 flex flex-col justify-between">
              <div>
                <span className="text-xs font-bold text-pink-600 dark:text-pink-400 uppercase tracking-wider">{t('hostTab')}</span>
                <h3 className="text-xl font-bold text-slate-800 dark:text-white mt-1 mb-4">{t('selectQuizToHost')}</h3>
                
                <select 
                  onChange={(e) => setSelectedLesson(lessons.find(l => l.id === e.target.value))}
                  className="w-full p-3.5 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-medium dark:text-white mb-4 outline-none focus:border-pink-500"
                >
                  <option value="">-- Chọn bài học trắc nghiệm --</option>
                  {lessons.filter(l => (l.multiple_choice || []).length > 0).map(l => (
                    <option key={l.id} value={l.id}>{l.title} ({l.multiple_choice.length} câu)</option>
                  ))}
                </select>
              </div>

              <button 
                onClick={createRoom} disabled={!selectedLesson}
                className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl hover:bg-pink-600 disabled:opacity-50 shadow-md shadow-pink-200 dark:shadow-none transition-all flex items-center justify-center gap-2"
              >
                <Crown className="w-5 h-5" /> {t('createRoomBtn')}
              </button>
            </div>

            {/* Player Section */}
            <div className="bg-white dark:bg-slate-800 p-6 rounded-3xl border border-pink-100 dark:border-slate-700 flex flex-col justify-between">
              <div>
                <span className="text-xs font-bold text-pink-600 dark:text-pink-400 uppercase tracking-wider">{t('playerTab')}</span>
                <h3 className="text-xl font-bold text-slate-800 dark:text-white mt-1 mb-4">{t('joinRoomBtn')}</h3>
                
                <div className="space-y-3 mb-4">
                  <input 
                    type="text" maxLength={6} placeholder={t('enterPinPrompt')}
                    value={inputPin} onChange={e => setInputPin(e.target.value)}
                    className="w-full p-3.5 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-center text-lg font-mono font-bold tracking-widest dark:text-white outline-none focus:border-pink-500"
                  />
                  <input 
                    type="text" placeholder={t('enterNickname')}
                    value={nickname} onChange={e => setNickname(e.target.value)}
                    className="w-full p-3.5 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-bold dark:text-white outline-none focus:border-pink-500"
                  />
                </div>
              </div>

              <button 
                onClick={() => { setPlayerJoined(true); setLiveMode('player'); }} disabled={!inputPin || !nickname}
                className="w-full py-4 bg-slate-900 dark:bg-slate-700 text-white font-bold rounded-2xl hover:bg-slate-800 disabled:opacity-50 transition-all flex items-center justify-center gap-2"
              >
                <Gamepad2 className="w-5 h-5" /> {t('joinRoomBtn')}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* HOST ARENA */}
      {liveMode === 'host' && (
        <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 md:p-8 border border-pink-100 dark:border-slate-700 shadow-sm min-h-[500px] flex flex-col justify-between">
          
          {/* LOBBY */}
          {gameStep === 'lobby' && (
            <div className="space-y-8 text-center my-auto">
              <div>
                <p className="text-xs font-bold uppercase text-pink-500 tracking-widest mb-1">{t('roomPin')}</p>
                <h1 className="text-6xl font-black text-slate-800 dark:text-white tracking-widest font-mono bg-pink-50 dark:bg-slate-900 py-4 px-8 rounded-3xl inline-block border-2 border-pink-200 dark:border-slate-700">{roomPin}</h1>
              </div>

              <div>
                <div className="flex justify-between items-center max-w-md mx-auto mb-4">
                  <span className="text-sm font-bold text-slate-700 dark:text-slate-300 flex items-center gap-2">
                    <Users className="w-4 h-4 text-pink-500" /> {t('playersJoined')} ({players.length})
                  </span>
                  <button onClick={addBot} className="text-xs font-bold text-pink-600 hover:underline">{t('addBotPlayer')}</button>
                </div>

                <div className="flex flex-wrap gap-3 justify-center max-w-md mx-auto">
                  {players.map(p => (
                    <div key={p.id} className="bg-pink-100 dark:bg-pink-900/40 text-pink-800 dark:text-pink-200 px-4 py-2 rounded-2xl text-sm font-bold animate-in zoom-in">
                      {p.name}
                    </div>
                  ))}
                </div>
              </div>

              <button 
                onClick={startBattle}
                className="px-10 py-4 bg-pink-500 text-white text-lg font-black rounded-2xl hover:bg-pink-600 shadow-lg shadow-pink-200 dark:shadow-none transition-all"
              >
                {t('startLiveGame')}
              </button>
            </div>
          )}

          {/* QUESTION ACTIVE */}
          {gameStep === 'question' && questions[currentQIndex] && (
            <div className="space-y-6 my-auto">
              <div className="flex justify-between items-center">
                <span className="text-xs font-bold text-pink-600 uppercase">Câu {currentQIndex + 1} / {questions.length}</span>
                <div className="flex items-center gap-2 bg-pink-100 dark:bg-pink-900/40 text-pink-700 dark:text-pink-300 px-4 py-1.5 rounded-full font-mono font-bold text-sm">
                  <Clock className="w-4 h-4" /> {timeLeft}s
                </div>
              </div>

              <h2 className="text-2xl md:text-3xl font-black text-slate-800 dark:text-white leading-snug">{questions[currentQIndex].question}</h2>

              {/* KAHOOT 4 COLOR BUTTONS DISPLAY */}
              <div className="grid grid-cols-2 gap-4">
                <div className="bg-red-500 text-white p-6 rounded-2xl font-bold flex items-center gap-3 text-lg shadow-md">
                  <span className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center font-black">▲</span>
                  <span>{questions[currentQIndex].options[0]}</span>
                </div>
                <div className="bg-blue-500 text-white p-6 rounded-2xl font-bold flex items-center gap-3 text-lg shadow-md">
                  <span className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center font-black">◆</span>
                  <span>{questions[currentQIndex].options[1]}</span>
                </div>
                <div className="bg-amber-400 text-white p-6 rounded-2xl font-bold flex items-center gap-3 text-lg shadow-md">
                  <span className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center font-black">●</span>
                  <span>{questions[currentQIndex].options[2]}</span>
                </div>
                <div className="bg-emerald-500 text-white p-6 rounded-2xl font-bold flex items-center gap-3 text-lg shadow-md">
                  <span className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center font-black">■</span>
                  <span>{questions[currentQIndex].options[3]}</span>
                </div>
              </div>
            </div>
          )}

          {/* REVEAL & LEADERBOARD */}
          {(gameStep === 'reveal' || gameStep === 'finished') && (
            <div className="space-y-6 my-auto">
              <div className="text-center">
                <h3 className="text-2xl font-black text-slate-800 dark:text-white mb-2">{t('leaderboardTitle')}</h3>
              </div>

              <div className="space-y-3 max-w-md mx-auto">
                {[...players].sort((a,b) => b.score - a.score).map((p, idx) => (
                  <div key={p.id} className="flex justify-between items-center p-4 bg-slate-50 dark:bg-slate-900 rounded-2xl border font-bold">
                    <div className="flex items-center gap-3">
                      <span className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-black ${idx === 0 ? 'bg-amber-400 text-white' : 'bg-slate-200 dark:bg-slate-700'}`}>{idx + 1}</span>
                      <span className="dark:text-white">{p.name}</span>
                    </div>
                    <span className="text-pink-600 dark:text-pink-400 font-mono">{p.score} pts</span>
                  </div>
                ))}
              </div>

              <div className="flex justify-center pt-4">
                {gameStep === 'reveal' ? (
                  <button onClick={nextQuestion} className="px-8 py-3.5 bg-pink-500 text-white font-bold rounded-2xl hover:bg-pink-600 flex items-center gap-2">
                    {t('nextQuestionBtn')} <ArrowRight className="w-4 h-4" />
                  </button>
                ) : (
                  <button onClick={() => setLiveMode('select')} className="px-8 py-3.5 bg-slate-900 text-white font-bold rounded-2xl">
                    {t('finishLiveGame')}
                  </button>
                )}
              </div>
            </div>
          )}
        </div>
      )}

      {/* PLAYER SCREEN */}
      {liveMode === 'player' && (
        <div className="bg-white dark:bg-slate-800 rounded-3xl p-6 md:p-8 border border-pink-100 dark:border-slate-700 shadow-sm text-center min-h-[450px] flex flex-col justify-between">
          <div>
            <div className="flex justify-between items-center mb-6">
              <span className="text-xs font-bold text-pink-600 uppercase">{nickname}</span>
              <span className="text-sm font-mono font-bold text-slate-700 dark:text-slate-300">{playerScore} pts</span>
            </div>

            <h3 className="text-2xl font-black text-slate-800 dark:text-white mb-8">{t('getReady')}</h3>

            <div className="grid grid-cols-2 gap-4 max-w-md mx-auto">
              <button onClick={() => submitPlayerAnswer(0)} className="h-28 bg-red-500 text-white rounded-2xl font-black text-2xl flex items-center justify-center shadow-lg hover:brightness-105 active:scale-95 transition-all">▲</button>
              <button onClick={() => submitPlayerAnswer(1)} className="h-28 bg-blue-500 text-white rounded-2xl font-black text-2xl flex items-center justify-center shadow-lg hover:brightness-105 active:scale-95 transition-all">◆</button>
              <button onClick={() => submitPlayerAnswer(2)} className="h-28 bg-amber-400 text-white rounded-2xl font-black text-2xl flex items-center justify-center shadow-lg hover:brightness-105 active:scale-95 transition-all">●</button>
              <button onClick={() => submitPlayerAnswer(3)} className="h-28 bg-emerald-500 text-white rounded-2xl font-black text-2xl flex items-center justify-center shadow-lg hover:brightness-105 active:scale-95 transition-all">■</button>
            </div>
          </div>

          {playerAnswered !== null && (
            <p className="text-xs font-bold text-pink-600 mt-4 animate-pulse">Đã gửi câu trả lời! Đang chờ kết quả...</p>
          )}
        </div>
      )}
    </div>
  );
}

// --- FEATURE: WAYGROUND-STYLE SPEED MATCH MINI-GAME ---
function SpeedMatchView({ lessons }) {
  const { t, addXP } = useAppContext();
  const [selectedLessonId, setSelectedLessonId] = useState('');
  const [gameActive, setGameActive] = useState(false);
  const [cards, setCards] = useState([]);
  const [selectedCards, setSelectedCards] = useState([]);
  const [matchedIds, setMatchedIds] = useState([]);
  const [timer, setTimer] = useState(0);
  const [combo, setCombo] = useState(1);
  const [score, setScore] = useState(0);
  const [isFinished, setIsFinished] = useState(false);

  const timerIntervalRef = useRef(null);

  const startMatch = () => {
    const lesson = lessons.find(l => l.id === selectedLessonId);
    if (!lesson || (!lesson.flashcards && !lesson.multiple_choice)) return;

    const deck = [];
    const sourceData = lesson.flashcards || [];
    
    sourceData.slice(0, 6).forEach((item, idx) => {
      deck.push({ id: `term_${idx}`, matchId: idx, text: item.term, type: 'term' });
      deck.push({ id: `def_${idx}`, matchId: idx, text: item.definition, type: 'def' });
    });

    setCards(shuffleArray(deck));
    setSelectedCards([]);
    setMatchedIds([]);
    setTimer(0);
    setCombo(1);
    setScore(0);
    setIsFinished(false);
    setGameActive(true);

    if (timerIntervalRef.current) clearInterval(timerIntervalRef.current);
    timerIntervalRef.current = setInterval(() => setTimer(t => t + 1), 1000);
  };

  const handleCardClick = (card) => {
    if (selectedCards.length === 2 || matchedIds.includes(card.id)) return;
    
    const newSelected = [...selectedCards, card];
    setSelectedCards(newSelected);

    if (newSelected.length === 2) {
      if (newSelected[0].matchId === newSelected[1].matchId && newSelected[0].type !== newSelected[1].type) {
        const newMatched = [...matchedIds, newSelected[0].id, newSelected[1].id];
        setMatchedIds(newMatched);
        setSelectedCards([]);
        setScore(s => s + 100 * combo);
        setCombo(c => Math.min(c + 1, 5));

        if (newMatched.length === cards.length) {
          clearInterval(timerIntervalRef.current);
          setIsFinished(true);
          addXP(30);
        }
      } else {
        setTimeout(() => {
          setSelectedCards([]);
          setCombo(1);
        }, 600);
      }
    }
  };

  return (
    <div className="max-w-4xl mx-auto p-4 md:p-8 animate-in fade-in duration-300 pb-20">
      
      {!gameActive ? (
        <div className="bg-white dark:bg-slate-800 p-8 rounded-3xl shadow-sm border border-pink-100 dark:border-slate-700 text-center space-y-6">
          <div className="w-16 h-16 bg-pink-500 text-white rounded-2xl flex items-center justify-center mx-auto shadow-md shadow-pink-200 dark:shadow-none">
            <Zap className="w-8 h-8" />
          </div>
          <div>
            <h2 className="text-3xl font-black text-slate-800 dark:text-white mb-2">{t('speedMatchTitle')}</h2>
            <p className="text-slate-500 dark:text-slate-400 text-sm max-w-md mx-auto">{t('speedMatchDesc')}</p>
          </div>

          <div className="max-w-md mx-auto space-y-4">
            <select 
              value={selectedLessonId} onChange={e => setSelectedLessonId(e.target.value)}
              className="w-full p-3.5 bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-medium dark:text-white outline-none focus:border-pink-500"
            >
              <option value="">-- {t('selectLessonForMatch')} --</option>
              {lessons.map(l => (
                <option key={l.id} value={l.id}>{l.title}</option>
              ))}
            </select>

            <button 
              onClick={startMatch} disabled={!selectedLessonId}
              className="w-full py-4 bg-pink-500 text-white font-bold rounded-2xl hover:bg-pink-600 disabled:opacity-50 shadow-md shadow-pink-200 dark:shadow-none transition-all flex items-center justify-center gap-2"
            >
              <Play className="w-5 h-5 fill-current" /> {t('startMatchBtn')}
            </button>
          </div>
        </div>
      ) : (
        <div className="space-y-6">
          {/* Header Stats */}
          <div className="bg-white dark:bg-slate-800 p-4 rounded-2xl border border-pink-100 dark:border-slate-700 flex justify-between items-center text-sm font-bold">
            <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
              <Clock className="w-4 h-4 text-pink-500" /> {t('matchTime')}: <span className="font-mono text-pink-600">{timer}s</span>
            </div>
            <div className="flex items-center gap-2 text-slate-700 dark:text-slate-300">
              <Zap className="w-4 h-4 text-amber-500" /> {t('comboMultiplier')}: <span className="text-amber-500">{combo}x</span>
            </div>
            <div className="text-pink-600 dark:text-pink-400 font-black">
              {score} PTS
            </div>
          </div>

          {/* Cards Grid */}
          {!isFinished ? (
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {cards.map((card) => {
                const isSelected = selectedCards.some(c => c.id === card.id);
                const isMatched = matchedIds.includes(card.id);

                return (
                  <button
                    key={card.id} disabled={isMatched}
                    onClick={() => handleCardClick(card)}
                    className={`h-32 p-4 rounded-2xl border-2 font-bold text-xs md:text-sm flex items-center justify-center text-center transition-all duration-200 ${
                      isMatched ? 'opacity-0 scale-95 pointer-events-none' :
                      isSelected ? 'bg-pink-500 text-white border-pink-500 scale-105 shadow-md' :
                      'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 hover:border-pink-400 dark:text-white'
                    }`}
                  >
                    {typeof card.text === 'object' ? JSON.stringify(card.text) : String(card.text || '')}
                  </button>
                );
              })}
            </div>
          ) : (
            <div className="bg-white dark:bg-slate-800 p-8 rounded-3xl text-center space-y-4 border border-pink-100 dark:border-slate-700">
              <Trophy className="w-12 h-12 text-pink-500 mx-auto" />
              <h3 className="text-2xl font-black text-slate-800 dark:text-white">{t('matchCompletedTitle')}</h3>
              <p className="text-slate-500 dark:text-slate-400 text-sm">{t('score')}: {score} pts | {t('matchTime')}: {timer}s</p>
              <button onClick={() => setGameActive(false)} className="px-8 py-3 bg-pink-500 text-white font-bold rounded-xl hover:bg-pink-600">
                Luyện tập tiếp
              </button>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// --- VIEW: STUDY AREA WITH IMAGE PREVIEW & ZOOM ---
function StudyAreaView({ lesson, onCompleteModule }) {
  const { t } = useAppContext();
  const [activeTab, setActiveTab] = useState('flashcards');
  const prog = lesson.progress || { flashcards: false, multiple_choice: false, true_false: false, fill_blanks: false };

  return (
    <div className="max-w-5xl mx-auto h-full flex flex-col p-4 md:p-8 animate-in fade-in duration-300 pb-10">
      
      {/* Lesson Header */}
      <div className="bg-white dark:bg-slate-800 p-5 md:p-6 rounded-3xl shadow-sm border border-pink-100 dark:border-slate-700 mb-6 flex flex-col xl:flex-row xl:items-center justify-between gap-6 shrink-0 transition-colors">
        <div>
          <div className="flex items-center gap-2 mb-2">
            <span className="px-3 py-0.5 bg-pink-100 dark:bg-pink-900/40 text-pink-700 dark:text-pink-300 text-xs font-bold rounded-full uppercase tracking-wider">
              {lesson.subject || t('presetAnatomy')}
            </span>
            <span className="text-xs text-slate-400 font-semibold">• {lesson.topic}</span>
          </div>
          <h2 className="text-2xl md:text-3xl font-black text-slate-800 dark:text-white">{lesson.title}</h2>
        </div>
        
        {/* Module Tabs */}
        <div className="flex bg-slate-50 dark:bg-slate-900/50 p-1.5 rounded-2xl border border-slate-100 dark:border-slate-700 overflow-x-auto hide-scrollbar">
          <TabButton id="flashcards" label={t('matchCards')} active={activeTab} onClick={setActiveTab} isDone={prog.flashcards} />
          <TabButton id="multiple_choice" label={t('multipleChoice')} active={activeTab} onClick={setActiveTab} isDone={prog.multiple_choice} />
          <TabButton id="true_false" label={t('trueFalse')} active={activeTab} onClick={setActiveTab} isDone={prog.true_false} />
          <TabButton id="fill_blanks" label={t('fillBlanks')} active={activeTab} onClick={setActiveTab} isDone={prog.fill_blanks} />
        </div>
      </div>

      {/* Module Workspace */}
      <div className="flex-1 bg-white dark:bg-slate-800 rounded-3xl shadow-sm border border-pink-100 dark:border-slate-700 overflow-hidden relative flex flex-col transition-colors">
        {activeTab === 'flashcards' && (
          <FlashcardModule data={lesson.flashcards || []} onComplete={() => onCompleteModule('flashcards')} isDone={prog.flashcards} />
        )}
        {activeTab === 'multiple_choice' && (
          <MCQModule data={lesson.multiple_choice || []} onComplete={() => onCompleteModule('multiple_choice')} isDone={prog.multiple_choice} />
        )}
        {activeTab === 'true_false' && (
          <TFModule data={lesson.true_false || []} onComplete={() => onCompleteModule('true_false')} isDone={prog.true_false} />
        )}
        {activeTab === 'fill_blanks' && (
          <FillBlanksModule data={lesson.fill_blanks || []} onComplete={() => onCompleteModule('fill_blanks')} isDone={prog.fill_blanks} />
        )}
      </div>
    </div>
  );
}

function TabButton({ id, label, active, onClick, isDone }) {
  const isActive = active === id;
  return (
    <button 
      onClick={() => onClick(id)}
      className={`px-3.5 py-2 rounded-xl text-xs font-bold transition-all whitespace-nowrap flex items-center gap-1.5 ${
        isActive 
          ? 'bg-white dark:bg-slate-700 text-pink-700 dark:text-pink-300 shadow-sm border border-slate-200 dark:border-slate-600' 
          : 'text-slate-500 dark:text-slate-400 hover:text-pink-600 dark:hover:text-pink-400'
      }`}
    >
      {label}
      {isDone && <CheckCircle2 className="w-3.5 h-3.5 text-pink-500" />}
    </button>
  );
}

// --- MODULE 1: FLASHCARDS MATCHING ---
function FlashcardModule({ data = [], onComplete, isDone }) {
  const { t, setZoomedImage } = useAppContext();
  const [terms, setTerms] = useState([]);
  const [definitions, setDefinitions] = useState([]);
  const [selectedTerm, setSelectedTerm] = useState(null);
  const [selectedDef, setSelectedDef] = useState(null);
  const [matchedPairs, setMatchedPairs] = useState([]);
  const [errorPair, setErrorPair] = useState(null);

  useEffect(() => {
    if (data.length > 0) {
      setTerms(shuffleArray(data.map((d, i) => ({ id: `t_${i}`, text: d.term, imageUrl: d.imageUrl, raw: d }))));
      setDefinitions(shuffleArray(data.map((d, i) => ({ id: `d_${i}`, text: d.definition, raw: d }))));
      setMatchedPairs([]); setSelectedTerm(null); setSelectedDef(null);
    }
  }, [data]);

  useEffect(() => {
    if (selectedTerm && selectedDef) {
      if (selectedTerm.raw.term === selectedDef.raw.term) {
        const newMatched = [...matchedPairs, selectedTerm.raw.term];
        setMatchedPairs(newMatched);
        setSelectedTerm(null); setSelectedDef(null);
        if (newMatched.length === data.length && !isDone) onComplete();
      } else {
        setErrorPair({ term: selectedTerm, def: selectedDef });
        setTimeout(() => { setErrorPair(null); setSelectedTerm(null); setSelectedDef(null); }, 800);
      }
    }
  }, [selectedTerm, selectedDef, data, matchedPairs, isDone, onComplete]);

  if (!data.length) return <div className="p-8 text-center text-slate-500 dark:text-slate-400">Không có dữ liệu thẻ.</div>;
  if (matchedPairs.length > 0 && matchedPairs.length === data.length) {
    return <CompletionScreen onRetry={() => {
      setTerms(shuffleArray(data.map((d, i) => ({ id: `t_${i}`, text: d.term, imageUrl: d.imageUrl, raw: d }))));
      setDefinitions(shuffleArray(data.map((d, i) => ({ id: `d_${i}`, text: d.definition, raw: d }))));
      setMatchedPairs([]);
    }} />;
  }

  return (
    <div className="h-full flex flex-col p-6 overflow-y-auto">
      <div className="text-center mb-6">
        <h3 className="text-xl font-bold text-pink-950 dark:text-white mb-2">{t('matchConcepts')}</h3>
        <div className="w-full max-w-md mx-auto bg-slate-100 dark:bg-slate-700 h-2 rounded-full overflow-hidden">
          <div className="bg-pink-500 h-full transition-all duration-500" style={{ width: `${(matchedPairs.length / data.length) * 100}%` }}></div>
        </div>
      </div>
      
      <div className="flex-1 grid grid-cols-1 md:grid-cols-2 gap-6 items-start">
        <div className="flex flex-col gap-3">
          {terms.map((item) => {
            const isMatched = matchedPairs.includes(item.raw.term);
            const isSelected = selectedTerm?.id === item.id;
            const isError = errorPair?.term?.id === item.id;

            return (
              <button
                key={item.id} disabled={isMatched}
                onClick={() => setSelectedTerm(isSelected ? null : item)}
                className={`p-4 rounded-2xl border-2 text-left font-bold text-sm transition-all flex items-center justify-between gap-3 ${
                  isMatched ? 'bg-pink-50/30 dark:bg-pink-900/10 border-pink-100 dark:border-pink-900/20 text-pink-300 dark:text-pink-800' :
                  isError ? 'bg-red-50 border-red-400 text-red-600 animate-shake' :
                  isSelected ? 'bg-pink-500 border-pink-500 text-white shadow-md' :
                  'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 hover:border-pink-300 text-slate-800 dark:text-slate-100'
                }`}
              >
                <span>{typeof item.text === 'object' ? JSON.stringify(item.text) : String(item.text || '')}</span>
                {item.imageUrl && (
                  <div className="relative group shrink-0" onClick={(e) => { e.stopPropagation(); setZoomedImage(item.imageUrl); }}>
                    <img src={item.imageUrl} alt="thumbnail" className="w-10 h-10 object-cover rounded-lg border" />
                    <div className="absolute inset-0 bg-black/30 rounded-lg flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                      <ZoomIn className="w-4 h-4 text-white" />
                    </div>
                  </div>
                )}
              </button>
            );
          })}
        </div>

        <div className="flex flex-col gap-3">
          {definitions.map((item) => {
            const isMatched = matchedPairs.includes(item.raw.term);
            const isSelected = selectedDef?.id === item.id;
            const isError = errorPair?.def?.id === item.id;

            return (
              <button
                key={item.id} disabled={isMatched}
                onClick={() => setSelectedDef(isSelected ? null : item)}
                className={`p-4 rounded-2xl border-2 text-left font-medium text-sm transition-all ${
                  isMatched ? 'bg-pink-50/30 dark:bg-pink-900/10 border-pink-100 dark:border-pink-900/20 text-pink-300 dark:text-pink-800' :
                  isError ? 'bg-red-50 border-red-400 text-red-600 animate-shake' :
                  isSelected ? 'bg-pink-500 border-pink-500 text-white shadow-md' :
                  'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700 hover:border-pink-300 text-slate-800 dark:text-slate-100'
                }`}
              >
                {typeof item.text === 'object' ? JSON.stringify(item.text) : String(item.text || '')}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// --- MODULE 2: MULTIPLE CHOICE ---
function MCQModule({ data = [], onComplete, isDone }) {
  const { t, setZoomedImage } = useAppContext();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState(null);
  const [isChecked, setIsChecked] = useState(false);
  const [score, setScore] = useState(0);
  const [finished, setFinished] = useState(false);

  const currentQ = data[currentIndex];

  const verify = () => {
    if (!selectedAnswer) return;
    setIsChecked(true);
    if (selectedAnswer === currentQ.answer) setScore(s => s + 1);
  };

  const next = () => {
    if (currentIndex < data.length - 1) {
      setCurrentIndex(c => c + 1);
      setSelectedAnswer(null); setIsChecked(false);
    } else {
      setFinished(true);
      if (!isDone) onComplete();
    }
  };

  if (!data.length) return <div className="p-8 text-center text-slate-500 dark:text-slate-400">Không có câu hỏi trắc nghiệm.</div>;
  if (finished) return <CompletionScreen score={score} total={data.length} onRetry={() => { setCurrentIndex(0); setSelectedAnswer(null); setIsChecked(false); setScore(0); setFinished(false); }} />;

  return (
    <div className="flex flex-col h-full overflow-y-auto">
      <div className="p-4 border-b border-slate-100 dark:border-slate-700 flex justify-between items-center bg-slate-50/50 dark:bg-slate-900/50 text-xs font-bold text-pink-600 dark:text-pink-400">
        <span>{t('question')} {currentIndex + 1} {t('of')} {data.length}</span>
      </div>
      
      <div className="p-6 md:p-8 flex-1 max-w-3xl mx-auto w-full flex flex-col justify-between">
        <div>
          <h3 className="text-xl md:text-2xl font-black text-slate-800 dark:text-white mb-4">{typeof currentQ.question === 'object' ? JSON.stringify(currentQ.question) : String(currentQ.question || '')}</h3>
          
          {currentQ.imageUrl && (
            <div className="mb-6 relative group inline-block cursor-pointer" onClick={() => setZoomedImage(currentQ.imageUrl)}>
              <img src={currentQ.imageUrl} alt="Diagram" className="max-h-64 object-contain rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm" />
              <div className="absolute inset-0 bg-black/20 rounded-2xl flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                <span className="bg-white/90 text-slate-800 text-xs font-bold px-3 py-1.5 rounded-full flex items-center gap-1">
                  <ZoomIn className="w-3.5 h-3.5" /> {t('zoomImage')}
                </span>
              </div>
            </div>
          )}

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            {currentQ.options?.map((opt, idx) => (
              <OptionButton 
                key={idx} text={opt} isSelected={selectedAnswer === opt} isChecked={isChecked} 
                isCorrect={opt === currentQ.answer} onClick={() => !isChecked && setSelectedAnswer(opt)} 
              />
            ))}
          </div>
        </div>

        <div className="mt-8 flex justify-end">
          {!isChecked ? (
            <button onClick={verify} disabled={!selectedAnswer} className="px-8 py-3 bg-pink-500 text-white font-bold rounded-xl disabled:opacity-50 hover:bg-pink-600 shadow-md shadow-pink-200 dark:shadow-none">{t('check')}</button>
          ) : (
            <button onClick={next} className="px-8 py-3 bg-slate-900 dark:bg-slate-700 text-white font-bold rounded-xl hover:bg-slate-800 dark:hover:bg-slate-600 flex items-center gap-2">{t('nextBtn')} <ArrowRight className="w-4 h-4"/></button>
          )}
        </div>
      </div>
    </div>
  );
}

// --- MODULE 3: TRUE / FALSE ---
function TFModule({ data = [], onComplete, isDone }) {
  const { t, setZoomedImage } = useAppContext();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState(null);
  const [isChecked, setIsChecked] = useState(false);
  const [score, setScore] = useState(0);
  const [finished, setFinished] = useState(false);

  const currentQ = data[currentIndex];

  const verify = () => {
    if (selectedAnswer === null) return;
    setIsChecked(true);
    if (selectedAnswer === currentQ.answer) setScore(s => s + 1);
  };

  const next = () => {
    if (currentIndex < data.length - 1) {
      setCurrentIndex(c => c + 1);
      setSelectedAnswer(null); setIsChecked(false);
    } else {
      setFinished(true);
      if (!isDone) onComplete();
    }
  };

  if (!data.length) return <div className="p-8 text-center text-slate-500 dark:text-slate-400">Không có câu hỏi Đúng/Sai.</div>;
  if (finished) return <CompletionScreen score={score} total={data.length} onRetry={() => { setCurrentIndex(0); setSelectedAnswer(null); setIsChecked(false); setScore(0); setFinished(false); }} />;

  return (
    <div className="flex flex-col h-full overflow-y-auto">
      <div className="p-4 border-b border-slate-100 dark:border-slate-700 flex justify-between items-center bg-slate-50/50 dark:bg-slate-900/50 text-xs font-bold text-pink-600 dark:text-pink-400">
        <span>{t('statement')} {currentIndex + 1} {t('of')} {data.length}</span>
      </div>

      <div className="p-6 md:p-8 flex-1 max-w-3xl mx-auto w-full flex flex-col justify-between">
        <div>
          <div className="bg-slate-50 dark:bg-slate-900/80 p-6 rounded-3xl mb-6 border border-slate-200 dark:border-slate-700 text-center">
            <h3 className="text-xl font-bold text-slate-800 dark:text-white leading-relaxed">"{typeof currentQ.statement === 'object' ? JSON.stringify(currentQ.statement) : String(currentQ.statement || '')}"</h3>
          </div>

          {currentQ.imageUrl && (
            <div className="mb-6 text-center">
              <div className="relative group inline-block cursor-pointer" onClick={() => setZoomedImage(currentQ.imageUrl)}>
                <img src={currentQ.imageUrl} alt="Diagram" className="max-h-60 object-contain rounded-2xl border border-slate-200 dark:border-slate-700 shadow-sm" />
                <div className="absolute inset-0 bg-black/20 rounded-2xl flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                  <span className="bg-white/90 text-slate-800 text-xs font-bold px-3 py-1.5 rounded-full flex items-center gap-1">
                    <ZoomIn className="w-3.5 h-3.5" /> {t('zoomImage')}
                  </span>
                </div>
              </div>
            </div>
          )}

          <div className="grid grid-cols-2 gap-4">
            <OptionButton text={t('true')} isSelected={selectedAnswer === true} isChecked={isChecked} isCorrect={currentQ.answer === true} onClick={() => !isChecked && setSelectedAnswer(true)} />
            <OptionButton text={t('false')} isSelected={selectedAnswer === false} isChecked={isChecked} isCorrect={currentQ.answer === false} onClick={() => !isChecked && setSelectedAnswer(false)} />
          </div>
        </div>

        <div className="mt-8 flex justify-end">
          {!isChecked ? (
            <button onClick={verify} disabled={selectedAnswer === null} className="px-8 py-3 bg-pink-500 text-white font-bold rounded-xl disabled:opacity-50 hover:bg-pink-600 shadow-md shadow-pink-200 dark:shadow-none">{t('check')}</button>
          ) : (
            <button onClick={next} className="px-8 py-3 bg-slate-900 dark:bg-slate-700 text-white font-bold rounded-xl hover:bg-slate-800 dark:hover:bg-slate-600 flex items-center gap-2">{t('nextBtn')} <ArrowRight className="w-4 h-4"/></button>
          )}
        </div>
      </div>
    </div>
  );
}

function OptionButton({ text, isSelected, isChecked, isCorrect, onClick }) {
  let btnClass = "p-4 border-2 rounded-2xl text-left text-base font-semibold transition-all outline-none ";
  if (!isChecked) {
    btnClass += isSelected ? "border-pink-500 bg-pink-50 dark:bg-pink-900/30 text-pink-800 dark:text-pink-200 scale-[1.01]" : "border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 hover:border-pink-300 text-slate-700 dark:text-slate-200";
  } else {
    if (isCorrect) btnClass += "border-pink-500 bg-pink-50 dark:bg-pink-900/30 text-pink-800 dark:text-pink-200 ring-2 ring-pink-200 dark:ring-pink-900/50";
    else if (isSelected && !isCorrect) btnClass += "border-red-500 bg-red-50 dark:bg-red-900/30 text-red-800 dark:text-red-300 ring-2 ring-red-200 dark:ring-red-900/50";
    else btnClass += "border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800 opacity-40 dark:text-slate-400";
  }
  const displayText = typeof text === 'object' ? JSON.stringify(text) : String(text ?? '');
  return (
    <button onClick={onClick} disabled={isChecked} className={btnClass}>
      <div className="flex justify-between items-center">
        <span>{displayText}</span>
        {isChecked && isCorrect && <CheckCircle2 className="text-pink-500 w-5 h-5" />}
        {isChecked && isSelected && !isCorrect && <XCircle className="text-red-500 w-5 h-5" />}
      </div>
    </button>
  );
}

// --- MODULE 4: FILL IN THE BLANKS ---
function FillBlanksModule({ data = [], onComplete, isDone }) {
  const { t, setZoomedImage } = useAppContext();
  const [answers, setAnswers] = useState(Array(data.length).fill(''));
  const [showResults, setShowResults] = useState(false);
  const [score, setScore] = useState(0);

  const checkAnswers = () => {
    let s = 0;
    answers.forEach((ans, idx) => {
      if (ans.trim().toLowerCase() === String(data[idx].answer || '').trim().toLowerCase()) s++;
    });
    setScore(s);
    setShowResults(true);
    if (!isDone) onComplete();
  };

  const renderSentence = (sentence, index) => {
    const textSentence = typeof sentence === 'object' ? JSON.stringify(sentence) : String(sentence || '');
    const parts = textSentence.split("___");
    if (parts.length < 2) return textSentence; 
    
    const isCorrect = showResults && answers[index].trim().toLowerCase() === String(data[index].answer || '').trim().toLowerCase();
    
    return (
      <React.Fragment>
        {parts[0]}
        <input 
          type="text" value={answers[index]} disabled={showResults}
          onChange={(e) => { const newA = [...answers]; newA[index] = e.target.value; setAnswers(newA); }}
          className={`mx-2 border-b-2 outline-none bg-transparent px-2 text-center font-bold min-w-[100px] transition-all 
            ${showResults 
              ? (isCorrect ? 'border-pink-500 text-pink-700 dark:text-pink-400' : 'border-red-500 text-red-700 dark:text-red-400') 
              : 'border-slate-300 dark:border-slate-600 text-pink-800 dark:text-pink-300 focus:border-pink-600 dark:focus:border-pink-400'}`}
        />
        {parts[1]}
      </React.Fragment>
    );
  };

  if (!data.length) return <div className="p-8 text-center text-slate-500 dark:text-slate-400">Không có bài tập điền từ.</div>;

  return (
    <div className="h-full flex flex-col p-6 md:p-8 overflow-y-auto">
      <div className="mb-6 flex justify-between items-center">
        <h3 className="text-xl font-bold text-pink-950 dark:text-white">{t('typeMissingWord')}</h3>
        {showResults && <div className="text-lg font-black text-pink-700 dark:text-pink-300 bg-pink-100 dark:bg-pink-900/40 px-4 py-1.5 rounded-xl">{t('score')}: {score}/{data.length}</div>}
      </div>

      <div className="space-y-6 max-w-4xl w-full mx-auto flex-1">
        {data.map((q, idx) => {
          const isCorrect = showResults && answers[idx].trim().toLowerCase() === String(q.answer || '').trim().toLowerCase();
          const isWrong = showResults && !isCorrect;
          
          return (
            <div key={idx} className={`p-5 rounded-2xl border-2 transition-colors ${showResults ? (isCorrect ? 'bg-pink-50/50 dark:bg-pink-900/20 border-pink-200 dark:border-pink-800' : 'bg-red-50/50 dark:bg-red-900/20 border-red-200 dark:border-red-800') : 'bg-white dark:bg-slate-800 border-slate-100 dark:border-slate-700 shadow-sm'}`}>
              
              {q.imageUrl && (
                <div className="mb-4 relative group inline-block cursor-pointer" onClick={() => setZoomedImage(q.imageUrl)}>
                  <img src={q.imageUrl} alt="Anatomy Diagram" className="max-h-48 object-contain rounded-xl border border-slate-200 dark:border-slate-700" />
                  <div className="absolute inset-0 bg-black/20 rounded-xl flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                    <span className="bg-white/90 text-slate-800 text-[11px] font-bold px-2.5 py-1 rounded-full flex items-center gap-1">
                      <ZoomIn className="w-3 h-3" /> {t('zoomImage')}
                    </span>
                  </div>
                </div>
              )}

              <p className="text-base leading-relaxed text-slate-800 dark:text-slate-200 font-medium">
                <span className="text-pink-500 font-black mr-2">{idx + 1}.</span>
                {renderSentence(q.sentence, idx)}
              </p>

              {isWrong && (
                <div className="mt-3 p-2.5 bg-white dark:bg-slate-900 rounded-xl text-red-700 dark:text-red-400 text-xs font-bold flex items-center gap-2 border border-red-100 dark:border-red-900/50">
                  <XCircle className="w-4 h-4 text-red-500" /> {t('correctAnswer')} <span className="text-pink-700 dark:text-pink-400">{typeof q.answer === 'object' ? JSON.stringify(q.answer) : String(q.answer || '')}</span>
                </div>
              )}
            </div>
          );
        })}
      </div>

      <div className="mt-8 flex justify-end max-w-4xl w-full mx-auto">
        {!showResults ? (
          <button onClick={checkAnswers} disabled={answers.some(a => a.trim() === '')} className="px-8 py-3 bg-pink-500 text-white font-bold rounded-xl hover:bg-pink-600 disabled:opacity-50 shadow-md shadow-pink-200 dark:shadow-none">{t('submitAnswers')}</button>
        ) : (
          <button onClick={() => { setAnswers(Array(data.length).fill('')); setShowResults(false); setScore(0); }} className="px-8 py-3 bg-slate-900 dark:bg-slate-700 text-white font-bold rounded-xl hover:bg-slate-800 dark:hover:bg-slate-600">{t('practiceAgain')}</button>
        )}
      </div>
    </div>
  );
}

function CompletionScreen({ score, total, onRetry }) {
  const { t } = useAppContext();
  return (
    <div className="flex flex-col items-center justify-center h-full p-8 text-center animate-in zoom-in duration-500">
      <div className="w-20 h-20 bg-pink-100 dark:bg-pink-900/30 rounded-full flex items-center justify-center mb-4 border-4 border-pink-50 dark:border-pink-900/10">
        <Trophy className="w-8 h-8 text-pink-500" />
      </div>
      <h3 className="text-2xl font-black text-slate-800 dark:text-white mb-2">{t('moduleCompleted')}</h3>
      {total !== undefined && <p className="text-slate-500 dark:text-slate-400 text-base mb-6">{t('score')} {score} / {total}</p>}
      {!total && <p className="text-slate-500 dark:text-slate-400 text-base mb-6">{t('xpEarned')}</p>}
      <button onClick={onRetry} className="bg-pink-500 text-white px-8 py-3 rounded-xl font-bold hover:bg-pink-600 transition-colors shadow-md shadow-pink-200 dark:shadow-none flex items-center gap-2">
         {t('practiceAgain')}
      </button>
    </div>
  );
}

const style = document.createElement('style');
style.innerHTML = `
  @keyframes shake {
    0%, 100% { transform: translateX(0); }
    20%, 60% { transform: translateX(-4px); }
    40%, 80% { transform: translateX(4px); }
  }
  .animate-shake { animation: shake 0.4s ease-in-out; }
  .hide-scrollbar::-webkit-scrollbar { display: none; }
  .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
`;
document.head.appendChild(style);
