<template>
  <div class="partList container-fluid py-4">
    <div class = "title" >
       <h3>공정 흐름도 관리</h3>
    </div>
    <div class="main-container" style="width: 800px; height: auto; ">
        <div class="content" style="height: auto;">
            <form class="row gx-3 gy-2 align-items-center">
                <div class="grid-container" style="padding-top: 10px; ">
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
            </form>
        </div>
    </div>
<div>
    <processflowModal :isShowModal="isShowModal"
        @closeModal="closeModal"
        @confirm="confirm"
        :modalTitle="modalTitle"
        :productCode="selectedProductCode"
        :productName="selectedProductName"
        @selectProcessflow = "setSelectProcessflow"
        style="z-index : '-1';"
        >
    </processflowModal>
</div>
</div>
</template>
<script>
import theme from "@/utils/agGridTheme";
import axios from 'axios';
import { ajaxUrl } from '@/utils/commons.js';
import processflowModal from "./processflowModal.vue";
import { mapMutations } from "vuex";

    export default {
        components:{processflowModal},
        data(){
            return {
                isShowModal : false, // 공정흐름도 조회 버튼 클릭시 나오는 모달
                modalType:'',
                modalTitle:'공정 흐름도',
                selectedProductCode: 'null',
                selectedProductName: '',
                columnDefs:[
                    {headerName:"제품명" , field:"product_name"},
                    {headerName:"제품코드" , field:"product_code"},
                    {
                        headerName:"공정흐름도조회",
                        field:"공정흐름도조회",
                        cellStyle: { textAlign: 'center' },
                        editable:false,
                        cellRenderer: (params) => {
                            const button1 = document.createElement('button');
                            button1.innerText = '공정흐름도조회';
                            button1.style.marginRight = '10px';
                            button1.style.cursor = 'pointer';
                            button1.style.backgroundColor = '#f7b84d';
                            button1.style.width = '120px';
                            button1.style.height = '30px';
                            button1.style.color = 'white';
                            button1.style.border = 'none';
                            button1.style.padding = '0';
                            button1.style.borderRadius = '4px';
                            button1.style.textAlign = 'center';
                            button1.style.lineHeight = '30px';
                            button1.addEventListener('click', () => {
                            
                            event.preventDefault();
                            this.selectedProductCode = params.data.product_code;
                            this.selectedProductName = params.data.product_name;
                            console.log("레코드 확인 : ", JSON.stringify(params.data));
                            this.openModal('processflowModal');
                            console.log('오픈 모달');
                            });
                            return button1;
                        }
                    },
                ],
                newList:[],
                rowData:[],
                theme:theme,
            };
        },
        // watch:{
        //         productCode:{
        //         handler:"flowList",
        //         immediate:true,
        //     },
        // },
        methods:{
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
            onReady(param){
                param.api.sizeColumnsToFit();
            },
            confirm() {
                console.log('값 저장')
                this.closeModal()
            },
            // async flowList() {
            //     console.log('제품코드 확인',this.productCode);
            //     let result = await axios.get(`${ajaxUrl}/flowList/${this.productCode}`)
            //     if(result && result.data){
            //     this.flowSelect = result.data;
            //     console.log("연결성공");
            //     this.rowData = result.data;
            //     }else {
            //     console.log("연결실패");
            //     }
            // },
            openModal(modalType) {
                this.modalType = modalType;
                this.modalTitle = '공정 흐름도'

                this.isShowModal = true;
            },
            closeModal() {
                this.isShowModal = false;
            },
            // onCellClicked(params){
            //     if(params.colDef.field !== '삭제'){
            //         console.log("확인 : ",JSON.stringify(params.data));
            //     }
            // },
            async productSelect(){
                const result = await axios.get(`${ajaxUrl}/bomproduct`)
                                        .catch(err => console.log(err));
                this.rowData = result.data;
            },

        },
        mounted() { // 페이지 조회시 바로 발생
            this.checkLogin();
            this.productSelect();
        },
    };
</script>
<style lang="scss" scoped>
.main-container{
    background-color:  #e9ecef;
    margin-left: 20px;
    margin-right: 20px;
    margin-top: 0px;
    margin-bottom: 0px;
    border-radius: 10px;
}
.content{
   margin-left: 20px;
   margin-right: 20px;
   margin-top: 0px;
   margin-bottom: 0px;
   padding: 0px;
}
input {
      background-color: white;
      border: solid 1px  ;
}
input:focus {
  background-color: #ffffff; /* 포커스 시 배경색 흰색 유지 */
  border-color: #86b7fe; /* 선택 시 테두리 색상 약간 강조 */
  outline: none; /* 기본 브라우저 포커스 아웃라인 제거 */
}
</style>