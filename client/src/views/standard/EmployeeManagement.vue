<!--사원 관리 메뉴-->
<template>
  <div class="partList container-fluid py-4">
<div>
    <h3>&nbsp;&nbsp;사원 관리</h3>
</div>
<div class="d-flex">
    <div class="p-2 flex-fill" style="width: 500px;">
         <!-- 검색 메뉴 레이아웃 -->
 <div class="main-container" style="width:450px;">
    <div class="content" style="height: auto; width: 400px ; margin: 20px; padding-bottom: 30px;" >
       <form class="d-flex flex-column">
        <div class="d-flex">
                  <div class="p-2 flex-fill">
                      <!-- 사원번호 -->
                      <div class="mb-3">
                         <label class="col-form-label fw-bold" for="empNum">사원번호</label>
                         <input type="text" placeholder="ex)20250000"  autocomplete="off"  class="form-control" style="background-color: white; " id="empNum" v-model="empNum" >
                      </div>
                      <!-- 생년월일 -->
                      <div class="mb-3">
                         <label class="col-form-label fw-bold" for="birth">생년월일</label>
                         <input type="date" class="form-control"  autocomplete="off"  style="background-color: white; padding-left: 20px;" id="birth" v-model="birth" >
                      </div>
                      <!-- 부서 -->
                      <div class="mb-3">
                        <label class="col-form-label fw-bold" for="job">부서</label>
                        <select
                          class="form-select"
                          v-model="job"
                          @change="updateJobNum"
                          style="background-color: white; text-align: center; border: solid 1px;"
                          aria-label="부서 선택"
                        >
                          <option value="">부서 선택</option>
                          <option value="영업">영업</option>
                          <option value="생산">생산</option>
                          <option value="자재">자재</option>
                          <option value="품질">품질</option>
                          <option value="설비">설비</option>
                          <option value="인사">인사</option>
                        </select>
                      </div>
                        <!-- 직급 -->
                      <div class="mb-3">
                        <label class="col-form-label fw-bold" for="position">직급</label>
                        <select
                          class="form-select"
                          v-model="position"
                          style="background-color: white; text-align: center; border: solid 1px;"
                          aria-label="부서 선택"
                        >
                          <option value="">직급 선택</option>
                          <option value="사원">사원</option>
                          <option value="반장">반장</option>
                          <option value="관리자">관리자</option>
                          <option value="사장">사장</option>
                          <option value="이사">이사</option>
                          <option value="대리">대리</option>
                        </select>
                      </div>
                      <!-- 입사일 -->
                      <div class="mb-3">
                         <label class="col-form-label fw-bold" for="employmentDate">입사일</label>
                         <input type="date"  autocomplete="off"  class="form-control" style="background-color: white; padding-left: 20px;" id="employmentDate" v-model="employmentDate" >
                      </div>
                  </div>
                  <div class="p-2 flex-fill">
                      <!-- 이름 -->
                      <div class="mb-3">
                         <label class="col-form-label fw-bold" for="name">이름</label>
                         <input type="text" class="form-control"  autocomplete="off"  style="background-color: white; padding-left: 20px;" id="name" v-model="name" >
                      </div>
                         <!-- 연락처 -->
                         <div class="mb-3">
                            <label class="col-form-label fw-bold" for="tel">연락처</label>
                            <input type="tel"  autocomplete="off"  class="form-control" placeholder="010-0000-0000" style="background-color: white; padding-left: 20px;" id="tel" v-model="tel" >
                        </div>
                        <!-- 부서번호 -->
                        <div class="mb-3">
                            <label class="col-form-label fw-bold" for="jobNum">부서번호</label>
                            <input type="text" placeholder="부서 선택시 자동입력" class="form-control" style="background-color: white; padding-left: 20px;" id="jobNum='101'" v-model="jobNum" readonly >
                        </div>
                        <!-- 등급 -->
                        <div class="mb-3">
                           <label class="col-form-label fw-bold" for="level">등급</label>
                                <div id="level" style="padding-left: 0px;">
                                <select class="form-select" v-model="level" style="width: 184px; border: solid 1px; background-color: white; text-align: center;" aria-label="관리 등급 선택">
                                        <option value="">1</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                </select>
                                </div>
                           <!-- <input type="text" class="form-control" style="background-color: white; padding-left: 20px;" id="level" v-model="level" > -->
                        </div>
                        <!-- 퇴사일 -->
                        <div class="mb-3">
                           <label class="col-form-label fw-bold" for="resignationDate">퇴사일</label>
                           <input type="date" class="form-control" style="background-color: white; padding-left: 20px;" id="resignationDate" v-model="resignationDate" >
                        </div>
                  </div>
                </div>
          <!-- 저장 버튼 -->
          <div class="col-sm-5">
            <div class="d-flex">
              <div class="p-2 flex-fill">
                <button style="position:relative; width:120px ; top:29px;" type="button" class="btn btn-success me-5" @click="input_update" text-align: right >등록/수정</button>
              </div>
              <div class="p-2 flex-fill">
                <button style="position:relative; width:120px ; top:29px;" type="button" class="btn btn-warning me-5" @click="refresh"  >새로고침</button>
              </div>
          </div>
        </div>
       </form>
    </div>
        <!-- 검색 메뉴 레이아웃 끝 -->
    </div>
</div>
    <div class="p-2 flex-fill" style="width: 1000px;">
        <div class="grid-container" style="padding-top: 10px;">
            <ag-grid-vue
            :rowData="rowData"
            :columnDefs="columnDefs"
            :theme="theme"
            :pagination="true"
            :paginationPageSize="10"
            @grid-ready="onReady"
            style="height: 513px;"
            rowSelection="multiple"
            @cellClicked="onCellClicked"
            >
            </ag-grid-vue>
        </div>
    </div>
</div>
<deleteModal
      :showModal="showDeleteModal"
      @deleteConfirmed="onDeleteConfirmed"
      @deleteCancelled="onDeleteCancelled"
 />
  </div>
 </template>
 <script>
 import axios from 'axios';
 import { ajaxUrl } from '@/utils/commons.js';
 // import userDateUtils from '@/utils/useDates.js';
 import theme from "@/utils/agGridTheme";
 import { mapMutations } from "vuex";
 import deleteModal from './deleteModal.vue';
 export default {
    components: {
        deleteModal, // 모달 컴포넌트 등록
    },
   data() {
     return {
        empNum: '',   // 사원번호
        name: '', // 이름
        birth: '',  // 생년월일
        tel: '', // 연락처
        job: '',  // 부서
        jobNum: '', // 부서번호
        position: '', // 직급
        level: '', // 등급
        employmentDate: '', // 입사일
        resignationDate: '', // 퇴사일
        showDeleteModal: false, // 삭제 모달 표시 여부
        selectedEmployee: null,
       columnDefs: [
         { headerName: "사원번호", field: "emp_num", width: 220 ,cellStyle: { textAlign: 'right' }},
         { headerName: "이름", field: "name" },
         { headerName: "연락처", field: "tel" ,cellStyle: { textAlign: 'center' }},
         { headerName: "부서", field: "job" },
        //  { headerName: "부서번호", field: "job_num" },
         { headerName: "직급", field: "position" },
         {
           headerName: "사원삭제",
           field: "삭제",
           upin : '',
           editable: false,
           cellStyle: { textAlign: 'center' },
           cellRenderer: (params) => {
             const button2 = document.createElement('button');
             button2.innerText = '삭제';
             button2.style.marginRight = '10px';
             button2.style.cursor = 'pointer';
             button2.style.backgroundColor = '#f44335';
             button2.style.width = '60px';
             button2.style.height = '30px';
             button2.style.color = 'white';
             button2.style.border = 'none';
             button2.style.padding = '0';
             button2.style.borderRadius = '4px';
             button2.style.textAlign = 'center';
             button2.style.lineHeight = '30px';
             button2.addEventListener('click', () => {
               console.log("레코드 확인[삭제] : ", JSON.stringify(params.data));
               console.log("삭제할 사원번호 : ", params.data.emp_num , "이름 : ", params.data.name);
               this.selectedEmployee = params.data;
               this.showDeleteModal = true;
             });
             return button2;
           }
         },
       ],
       newList: [], // 등록 , 수정
       rowData: [], // 데이터 잡아넣을 그리드 api 행
       theme:theme,
     };
   },
   methods: {
    onDeleteCancelled() {
      this.showDeleteModal = false;
    },
    async onDeleteConfirmed() {
      if (this.selectedEmployee) {
        try{
          axios.delete(`${ajaxUrl}/employeeDelete/${this.selectedEmployee.emp_num}`)
            .then(res => {
              if (res.data === '성공') {
               this.$notify({ text: '사원이 삭제되었습니다.', type: 'success' });
                this.employeeList();
              } else {
               this.$notify({ text: '삭제실패하였습니다.', type: 'error' });
              }
            })

        }catch(error) {
          console.log(error);
          this.$notify({ text: '삭제실패하였습니다.', type: 'error' });
        }
        this.showDeleteModal = false;
    }
  },
    refresh(){
            this.employeeList();
            this.upin = '';
            this.empNum = '';
            this.name = '';
            this.birth = '';
            this.tel = '';
            this.job = '';
            this.jobNum = '';
            this.position = '';
            this.level = '';
            this.employmentDate = '';
            this.resignationDate = '';
    },
    updateJobNum() {
    console.log('hjkhjkhkj',this.job);
      // 부서에 맞는 부서번호를 설정
      const departmentJobNumbers = {
        "영업": "1",
        "생산": "2",
        "자재": "3",
        "품질": "4",
        "설비": "5",
        "인사": "6",
      };
      this.jobNum = departmentJobNumbers[this.job] || ''; // 부서번호 설정
    },
    async employeeList() {
        const result = await axios.get(`${ajaxUrl}/employeeList`)
                                  .catch(err => console.log(err));
          this.rowData = result.data;
    },
    ...mapMutations(["addLoginInfo"]),
      async checkLogin(){
          this.loginInfo = this.$store.state.loginInfo;
          console.log('직업',this.loginInfo);
          if(this.loginInfo.job === 'Administrator'){
            console.log('성공');
          }else{
              this.$notify({ text: '관리자만 접속 가능합니다.', type: 'error' });
              this.$router.push({ name : 'MainPage' });
          }
      },
    onReady(param) {
      param.api.sizeColumnsToFit(); // 그리드 api 넓이 슬라이드 안 생기게 하는 거
    },
    onCellClicked(params) {
        if(params.colDef.field !== '삭제'){   
          console.log("레코드 확인[클릭] : ", JSON.stringify(params.data));
            this.empNum = params.data.emp_num;
            this.name = params.data.name;
            this.birth = params.data.birth;
            this.tel = params.data.tel;
            this.job = params.data.job;
            this.jobNum = params.data.job_num;
            this.position = params.data.position;
            this.level = params.data.level;
            this.employmentDate = params.data.employment_date;
            this.resignationDate = params.data.resignation_date;
        }
    },
    async employeeInsert(newList){
      const empNumber = await axios.get(`${ajaxUrl}/employeeList`);
      const existingEmployee = empNumber.data.find(employee => employee.emp_num === newList.emp_num);
        const result = await axios.post(`${ajaxUrl}/employeeInsert`, newList)
                                  .catch(err => console.log(err));
            if (result.data === '성공') {
                  if(existingEmployee){
                    this.$notify({ text: '사원이 수정되었습니다.', type: 'success' });
                  }else{
                    this.$notify({ text: '사원이 등록되었습니다.', type: 'success' });
                  }
                  this.employeeList();
            }else {
              this.$notify({ text: '등록실패하였습니다.', type: 'error' });
            }
        console.log(result.data);
        this.employeeList();
    },
    input_update() {
      if(this.empNum === '' || this.name === '' || this.birth === '' || this.tel === '' || this.job === '' || this.jobNum === '' || this.position === '' || this.employmentDate === ''){
        this.$notify({ text: '빈칸을 입력해주세요', type: 'error' });
        return;
      }
      
      if(this.tel.length !== 13){
        this.$notify({ text: '연락처를 확인해주세요', type: 'error' });
        return;
      }

      console.log('등록 또는 수정 기능여기서 추가');
      this.newList = { emp_num: this.empNum,
                       name: this.name,
                       birth: this.birth, 
                       tel: this.tel, 
                       job: this.job, 
                       job_num: this.jobNum, 
                       position: this.position, 
                       level: this.level || null, 
                       employment_date: this.employmentDate, 
                       resignation_date: this.resignationDate || null };
      this.employeeInsert(this.newList);
      this.employeeList();
    },
   },
   // 화면 생성되는 시점
   mounted() {
     // 전체조회 쿼리 실행
     this.checkLogin();
     this.employeeList();
   },
 };
 </script>
 
 <style lang="scss" scoped>
input.form-control {
  padding-left: 20px;
  padding-right: 20px;
}
#birth{
text-align: center;
}
#tel{
text-align: center;
}
#employmentDate{
text-align: center;
}
#resignationDate{
  text-align: center;
}
 .main-container{
     background-color:  #e9ecef;
     margin-left: 20px;
     margin-right: 20px;
     margin-top: 0px;
     margin-bottom: 0px;
     border-radius: 10px;
 }
 .grid-container{
    margin-top: 9px;
 }
 .content{
    margin-left: 20px;
    margin-right: 20px;
    margin-top: 0px;
    margin-bottom: 0px;
    padding: 0px;
 }
 input {
       background-color: $white;
       border: solid 1px  ;
 }
 /* input 포커스 상태에서도 배경색 유지 */
input:focus {
  background-color: #ffffff; /* 포커스 시 배경색 흰색 유지 */
  border-color: #86b7fe; /* 선택 시 테두리 색상 약간 강조 */
  outline: none; /* 기본 브라우저 포커스 아웃라인 제거 */
}
 </style>