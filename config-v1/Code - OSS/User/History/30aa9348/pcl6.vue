<script>
	import { Head, Link } from "@inertiajs/inertia-vue3";
	import PageTemplate from "@/Layouts/PageTemplate.vue";
	import SideBar from "@/Layouts/Clients-View-SideBar.vue";
	import DragAndDropFileVue from "@/Layouts/DragAndDropFile.vue";

	import { ClientsSideBarItems, FormTypes } from "@/Scripts/Variables";
	import { TreeSearch } from "@/Scripts/TreeSearch";

	var csrf = document
		.querySelector('meta[name="csrf-token"]')
		.getAttribute("content");
	1;
	export default {
		name: "TaxAssociate-Dashboard",
		components: {
			SideBar,
			DragAndDropFileVue,
			PageTemplate,
			Head,
			Link,
		},
		props: {
			id: String,
			file_id: String,
		},
		methods: {
			ChangePanel(panel) {
				this.panel = panel;
			},
			AddFile(file) {
				this.panel = "add_files";
				this.panel_file = null;
				this.file_details.id = this.id;
				this.file_details.name = null;
				this.file_details.document_type = null;
				this.file_details.form_type = null;
				this.file_details.review = null;
				this.file_details.payment = null;
				this.file_details.status = null;
				this.file_details.date = new Date().toISOString().slice(0, 10);
			},
			EditFile(file) {
				this.panel = "edit_files";
				//
				this.file_details.file_id = this.panel_file.id;
				this.file_details.id = this.id;
				this.file_details.name = this.panel_file.name;
				this.file_details.document_type = this.panel_file.document_type;
				this.file_details.form_type = this.panel_file.form_type;
				this.file_details.review = this.panel_file.review;
				this.file_details.payment = this.panel_file.payment;
				this.file_details.status = this.panel_file.status;
				this.file_details.date = new Date().toISOString().slice(0, 10);
				this.LoadFormTypes(this.panel_file.document_type);
				// remove panel_file contents
				this.panel_file = null;
			},
			ArchiveFile(id) {
				Swal.fire({
					title: "Do you want to archive this file?",
					showDenyButton: true,
					confirmButtonText: "Save",
					denyButtonText: `Don't save`,
				}).then((res) => {
					if (res.isConfirmed) {
						axios({
							method: "post",
							url: "/files/delete",
							data: {
								file_id: id,
							},
						}).then((response) => {
							Swal.fire(
								"File Archived",
								"you can still view the file in the archive files tab."
							);
							this.Load();
							this.panel = null;
						});
					}
				});
			},
			RestoreFile(id) {
				Swal.fire({
					title: "Do you want to restore this file?",
					showDenyButton: true,
					confirmButtonText: "Save",
					denyButtonText: `Don't save`,
				}).then((res) => {
					if (res.isConfirmed) {
						axios({
							method: "post",
							url: "/files/restore",
							data: {
								file_id: id,
							},
						}).then((response) => {
							Swal.fire(
								"File Restored",
								"you can can now view the file in its previous location."
							);
							this.Load();
							this.panel = null;
						});
					}
				});
			},
			ViewHistory() {
				this.panel = "file_history";
				axios({
					method: "get",
					url: "/files/history",
					params: {
						client: this.id,
						file_id: this.panel_file.id,
					},
				}).then(async (response) => {
					let versions = await response.data.versions;
					let temp = [];
					for (let x = 0; x < versions; x++) {
						temp.unshift({
							file_name:
								this.panel_file.id + "_" + this.id + "_" + (x + 1) + ".pdf",
							version: x + 1,
							name: this.panel_file.name,
						});
					}
					this.history_files = temp;
				});
			},
			ViewFile(data) {
				this.panel = "view_files";
				this.panel_file = data;
			},
			ViewArchived() {
				this.panel = "archived_files";
				axios({
					method: "post",
					url: "/files/archived",
					data: {
						client: this.id,
					},
				}).then((response) => {
					this.archived_files = response.data;
				});
			},
			GetFileList(document_1, document_2, document_3, type, year) {
				axios({
					method: "post",
					url: "/files/retrieve",
					data: {
						client: this.id,
						document_1: document_1,
						document_2: document_2,
						document_3: document_3,
						type: type,
						year: year,
					},
				}).then((response) => {
					if (document_1 && !document_2 && !document_3) {
						response.data.forEach((item) => {
							let data = {
								name: item.name,
								file_name: item.file_name,
								status: item.status,
								document_type: item.document_type,
								form_type: item.form_type,
								review: item.review,
								payment: item.payment,
								id: item.file_id,
								type: "button",
								icon: "fa-file",
							};
							this.menu[document_1].submenu[data.id] = data;
						});
					} else if (document_1 && document_2 && !document_3) {
						let pop = [];
						response.data.forEach((item) => {
							let data = {
								name: item.name,
								file_name: item.file_name,
								status: item.status,
								document_type: item.document_type,
								form_type: item.form_type,
								review: item.review,
								payment: item.payment,
								id: item.file_id,
								type: "button",

								icon: "fa-file",
							};
							this.menu[document_1].submenu[document_2].submenu[data.id] = data;
						});
					} else if (document_1 && document_2 && document_3) {
						response.data.forEach((item) => {
							let data = {
								name: item.name,
								file_name: item.file_name,
								status: item.status,
								document_type: item.document_type,
								form_type: item.form_type,
								review: item.review,
								payment: item.payment,
								id: item.file_id,
								type: "button",
								icon: "fa-file",
							};
							this.menu[document_1].submenu[document_2].submenu[
								document_3
							].submenu[data.id] = data;
						});
					}
				});
			},
			LoadFormTypes(type) {
				this.form_types = FormTypes(type);
			},
			StoreFile() {
				Swal.fire({
					title: "Do you want to save the changes?",
					showDenyButton: true,
					confirmButtonText: "Save",
					denyButtonText: `Don't save`,
				}).then((res) => {
					if (res.isConfirmed) {
						let form = new FormData();

						form.append("pdf", this.panel_file);

						if (this.file_details.name) {
							form.append("name", this.file_details.name);
						}

						if (this.file_details.file_id) {
							form.append("id", this.file_details.file_id);
						}

						if (this.file_details.id) {
							form.append("id", this.file_details.id);
						}

						if (this.file_details.document_type) {
							form.append("document_type", this.file_details.document_type);
						}

						if (this.file_details.form_type) {
							form.append("form_type", this.file_details.form_type);
						}

						if (this.file_details.date) {
							form.append("date", this.file_details.date);
						}

						axios
							.post("/files/store", form, {
								headers: {
									"Content-Type": "multipart/form-data",
								},
							})
							.then(() => {
								console.log("SUCCESS!!");
								Swal.fire(
									"File Added",
									"file is succesfully uploaded",
									"success"
								).then(() => {
									this.panel = null;
								});
								this.Load();
								//this.$inertia.visit("/TA/clients/" + this.id);
							})
							.catch((errr) => {
								console.log(errr);
								Swal.fire(
									"Error Uploading File",
									"please verify that every info is provided.",
									"warning"
								);
							});
					}
				});
			},
			UpdateFile() {
				Swal.fire({
					title: "Do you want to save the changes?",
					showDenyButton: true,
					confirmButtonText: "Save",
					denyButtonText: `Don't save`,
				}).then((res) => {
					if (res.isConfirmed) {
						let form = new FormData();

						if (this.panel_file) {
							form.append("pdf", this.panel_file);
						}

						if (this.file_details.name) {
							form.append("name", this.file_details.name);
						}

						if (this.file_details.id) {
							form.append("id", this.file_details.id);
						}

						console.log(this.file_details);
						if (this.file_details.file_id) {
							form.append("file_id", this.file_details.file_id);
						}

						if (this.file_details.document_type) {
							form.append("document_type", this.file_details.document_type);
						}

						if (this.file_details.form_type) {
							form.append("form_type", this.file_details.form_type);
						}

						if (this.file_details.status) {
							form.append("status", this.file_details.status);
						}

						if (this.file_details.payment) {
							form.append("payment", this.file_details.payment);
						}

						if (this.file_details.date) {
							form.append("date", this.file_details.date);
						}

						axios
							.post("/files/edit", form, {
								headers: {
									"Content-Type": "multipart/form-data",
								},
							})
							.then(() => {
								console.log("SUCCESS!!");
								Swal.fire(
									"File Updated",
									"file is succesfully uploaded",
									"success"
								);
								this.Load(document.getElementById("year").value);
								//this.$inertia.visit("/TA/clients/" + this.id);
							})
							.catch((errr) => {
								console.log(errr);
								Swal.fire(
									"Error Uploading File",
									"please verify that every info is provided.",
									"warning"
								);
							});
					}
				});
			},
			FileToParent(file) {
				this.panel_file = file;
			},
			Load(year) {
				this.menu = ClientsSideBarItems();

				let promise = new Promise((resolve, reject) => {
					this.GetFileList("BIR", 2307, null, "2307", year);
					this.GetFileList("BIR", "TaxReturns", "Annual", "0605", year);
					this.GetFileList("BIR", "TaxReturns", "Percentage", "2551Q", year);
					this.GetFileList("BIR", "TaxReturns", "Income", "172Q/1702", year);

					this.GetFileList("Personal", null, null, "document", year);
					this.GetFileList("LGU", null, null, "document", year);
					this.GetFileList("DTI", null, null, "document", year);
					this.GetFileList("SEC", null, null, "document", year);
					resolve(this.menu);
				});

				promise.then((res) => {
					if (this.file_id && this.first_run) {
						let temp = setInterval(() => {
							this.NavigateTree(TreeSearch(res, this.file_id));
							clearInterval(temp);
							this.first_run = false;
						}, 1000);
					}
				});
			},
			NavigateTree(arr) {
				arr.map((item, i) => {
					if (i == 0) {
						this.Expanded(item);
					} else {
						let temp = "";
						let pointer = "this.menu";
						for (let count = 0; count <= i; count++) {
							temp += arr[count];
							pointer += "['" + arr[count] + "']";
							if (count != i) {
								temp += "_";
								pointer += ".submenu";
							}
						}
						if (i != arr.length - 1) {
							this.Expanded(temp);
						} else {
							this.ViewFile(eval(pointer));
						}
					}
				});
			},
			Expanded(i, timer) {
				$("#menu-content-parent-" + i).animate(
					{
						height: ["toggle"],
						opacity: ["toggle"],
					},
					timer == undefined ? 200 : timer
				),
					"swing";
			},
			ClientDetails() {
				axios({
					method: "post",
					url: "/search/customer_info",
					data: {
						id: this.id,
					},
				}).then((res) => {
					this.details = res.data;
				});
			},
			FileDetails() {
				axios({
					method: "get",
					url: "/files/details",
					data: {
						file_id: this.id,
					},
				}).then((res) => {
					this.details = res.data;
					this.file_details.review = null;
					this.file_details.payment = null;
					this.file_details.status = null;
				});
			},
			Download() {
				/*
				axios({
					method: "post",
					url: "/files/download",
					data: {
						file_path: this.panel_file.file_name,
					},
					config: { headers: { "Content-Type": "multipart/form-data" } },
				});
				*/
				let file_name =
					this.details.lastname +
					"-" +
					this.panel_file.form_type +
					"-" +
					this.panel_file.name;

				var url =
					"/files/download?file_path=" +
					this.panel_file.file_name +
					"&file_name=" +
					file_name;
				window.open(url);
			},
			Download() {
				/*
				axios({
					method: "post",
					url: "/files/download",
					data: {
						file_path: this.panel_file.file_name,
					},
					config: { headers: { "Content-Type": "multipart/form-data" } },
				});
				*/
				let file_name =
					this.details.lastname +
					"-" +
					this.panel_file.form_type +
					"-" +
					this.panel_file.name;

				var url =
					"/files/download?file_path=" +
					this.panel_file.file_name +
					"&file_name=" +
					file_name;
				window.open(url);
			},
			DownloadFile(file) {
				window.open("/files/download?file_path=" + file);
			},
		},
		mounted() {
			console.log(this.file_id);

			$("#drag-area").on("dragover", (event) => {
				if (this.file == null) {
					event.preventDefault();
					$("#drag-area").removeClass("is-light");
					$("#drag-area-file-button").addClass("is-light");
					$("#drag-area-header").html("Released to Upload File");
				}
				this.CheckIfFileEmpty();
			});

			$("#drag-area").on("dragleave", (event) => {
				if (this.file == null) {
					event.preventDefault();
					$("#drag-area").addClass("is-light");
					$("#drag-area-file-button").removeClass("is-light");
					$("#drag-area-header").html("Drag & Drop to Upload File");
				}
				this.CheckIfFileEmpty();
			});

			$("#drag-area").on("drop", (event) => {
				event.preventDefault();
				let file_type = event.originalEvent.dataTransfer.files[0].name
					.split(".")
					.pop();
				if (file_type == "pdf") {
					//console.log();
					$("#drag-area").addClass("is-light");
					$("#drag-area-file-button").removeClass("is-light");
					$("#drag-area-header").html("Drag & Drop to Upload File");
					this.file = event.originalEvent.dataTransfer.files[0];
					$("#drag-area-file-name").html(this.file.name);
				} else {
					event.preventDefault();
					$("#drag-area").addClass("is-light");
					$("#drag-area-file-button").removeClass("is-light");
					$("#drag-area-header").html("Drag & Drop to Upload File");
					Swal.fire("Upload only PDF files.", "", "warning");
				}
				this.CheckIfFileEmpty();
			});
			//this.GetFileList('monthly');
			this.Load(new Date().getFullYear()); // load files from current year
			this.ClientDetails();
		},
		data() {
			return {
				first_run: true, // check if first run
				file: null,
				file_details: {
					name: null,
					id: null,
					file_id: null,
					document_type: null,
					form_type: null,
					date: null,
					review: null,
					payment: null,
					status: null,
				},

				details: null,
				panel: null,
				panel_file: null,
				archived_files: null,
				history_files: null,
				menu: ClientsSideBarItems(),
				form_types: FormTypes("BIR"),
			};
		},
	};
</script>

<template>
	<Head title="View" />
	<PageTemplate>
		<template #body>
			<div class="notification is-white p-5">
				<div class="columns is-gapless">
					<div class="column is-2 narrow">
						<SideBar
							:AddFile="AddFile"
							:ViewFile="ViewFile"
							:GetFileList="GetFileList"
							:Load="Load"
							:menu="this.menu" />
					</div>
					<div class="column is-auto">
						<div>
							<nav class="level">
								<div class="level-left">
									<div class="level-item">
										<figure class="image is-64x64">
											<img
												class="is-rounded"
												src="https://bulma.io/images/placeholders/64x64.png" />
										</figure>
									</div>
									<div class="level-item">
										<div>
											<h1>hello{{ file_id }}</h1>
											<h1
												class="heading is-size-6"
												v-if="this.details">
												<b>Client</b> : {{ this.details.lastname }}
												{{ this.details.firstname }}
												{{ this.details.middlename }}
												{{ this.details.suffix }}
											</h1>
											<h1 class="heading is-size-6"><b>ID</b>: {{ id }}</h1>
										</div>
									</div>
								</div>
							</nav>
							<nav
								class="level p-0 m-0 mt-1 mb-2"
								style="height: 100% !important">
								<div class="level-left">
									<template
										v-if="
											(panel == 'view_files' || panel == 'file_history') &&
											panel_file
										">
										<div class="level-item">
											<label class="color-dark-text ml-1 mr-1">File:</label>
											<h5 class="tag is-medium">
												{{ panel_file.name }}
											</h5>
										</div>
										<div class="level-item">
											<label class="color-dark-text ml-1 mr-1">Status:</label>
											<h5 class="tag is-medium">
												{{ panel_file.status }}
												<!-- should contain one of values ['TO REVIEW', 'FILED', 'TO REVISE'] -->
											</h5>
										</div>
										<div class="level-item">
											<label class="color-dark-text ml-1 mr-1">Payment:</label>
											<h5 class="tag is-medium">
												{{ panel_file.payment }}
												<!-- should contain one of values ['UNPAID', 'PAID'] -->
											</h5>
										</div>
										<div class="level-item">
											<button
												class="button is-light is-medium tag"
												@click="this.ViewHistory()">
												<span class="icon">
													<i class="fa fa-file-lines"></i>
												</span>
												<span> File History </span>
											</button>
										</div>
									</template>
								</div>
								<div class="level-right">
									<template v-if="this.panel != 'add_files'">
										<p class="level-item">
											<button
												class="button is-danger color-red-text is-light"
												@click="this.AddFile()">
												<span class="icon">
													<i class="fa fa-add"></i>
												</span>
												<span> Add File </span>
											</button>
										</p>
									</template>
									<template v-if="this.panel == 'view_files'">
										<p class="level-item">
											<button
												class="button is-info"
												@click="Download">
												<span class="icon">
													<i class="fa fa-download"></i>
												</span>
												<span> Download File </span>
											</button>
										</p>
									</template>
									<template
										v-if="
											this.panel == 'view_files' || this.panel == 'file_history'
										">
										<p class="level-item">
											<button
												class="button is-warning"
												@click="EditFile()">
												<span class="icon">
													<i class="fa fa-edit"></i>
												</span>
												<span> Update File </span>
											</button>
										</p>
									</template>
									<template v-if="this.panel != 'archived_files'">
										<p class="level-item">
											<button
												class="button is-link"
												@click="ViewArchived()">
												<span class="icon">
													<i class="fa fa-archive"></i>
												</span>
												<span> Archived Files </span>
											</button>
										</p>
									</template>
								</div>
							</nav>
							<p class="is-divider mb-0 mt-0"></p>
						</div>
						<!-- VIEW FILES -->
						<div
							v-if="this.panel == 'view_files'"
							v-bind:id="'view_pdf'">
							<iframe
								v-if="panel_file"
								class="m-0 p-0"
								v-bind:src="'/files/get?file_name=' + this.panel_file.file_name"
								width="100%"
								height="1000px">
							</iframe>
						</div>

						<!-- ADD FILES -->
						<div
							v-else-if="this.panel == 'add_files'"
							v-bind:id="'add_files'">
							<div class="columns is-centered is-vcentered">
								<div class="column">
									<h1
										class="heading is-size-4 color-dark-text has-text-centered">
										<b> Add File </b>
									</h1>
									<div class="field">
										<label class="heading">Client ID</label>
										<div class="control">
											<input
												class="input"
												type="text"
												v-model="this.file_details.id"
												readonly />
										</div>
									</div>
									<div class="field">
										<label class="heading">Name</label>
										<div class="control">
											<input
												class="input"
												type="text"
												v-model="this.file_details.name" />
										</div>
									</div>
									<div class="field">
										<label class="heading">Document Type</label>
										<div class="control">
											<div class="select is-fullwidth">
												<select
													v-on:change="
														(event) => {
															this.LoadFormTypes(event.target.value);
															this.file_details.document_type =
																event.target.value;
															this.file_details.form_type = null;
														}
													">
													<option
														disabled
														selected>
														Choose Document Type
													</option>
													<option v-for="(opt, x) in this.menu">{{ x }}</option>
												</select>
											</div>
										</div>
									</div>
									<div class="field">
										<label class="heading">Form Type</label>
										<div class="control">
											<div class="select is-fullwidth">
												<select
													v-on:change="
														(event) => {
															this.file_details.form_type = event.target.value;
														}
													">
													<option
														disabled
														selected>
														Choose Form Type
													</option>
													<option v-for="item in this.form_types">
														{{ item }}
													</option>
												</select>
											</div>
										</div>
									</div>

									<div class="field">
										<label class="heading">Date</label>
										<div class="control">
											<input
												class="input"
												v-model="this.file_details.date"
												type="date" />
										</div>
									</div>
									<div class="field">
										<div class="control">
											<button
												class="button is-success"
												@click="StoreFile()">
												Submit
											</button>
										</div>
									</div>
								</div>
								<div class="column is-auto">
									<DragAndDropFileVue
										:FileToParent="FileToParent"
										:panel="this.panel" />
								</div>
							</div>
						</div>
						<!-- EDIT FILES  -->
						<div
							v-else-if="this.panel == 'edit_files'"
							v-bind:id="'edit_files'">
							<div class="columns is-centered is-vcentered">
								<div class="column">
									<h1
										class="heading is-size-4 color-dark-text has-text-centered">
										<b> Update File </b>
									</h1>
									<div class="field">
										<label class="heading">File ID</label>
										<div class="control">
											<input
												class="input"
												type="text"
												v-model="this.file_details.file_id"
												readonly />
										</div>
									</div>
									<div class="field">
										<label class="heading">Name</label>
										<div class="control">
											<input
												class="input"
												type="text"
												v-model="this.file_details.name" />
										</div>
									</div>
									<div class="field">
										<label class="heading">Document Type</label>
										<div class="control">
											<div class="select is-fullwidth">
												<select
													v-on:change="
														(event) => {
															this.LoadFormTypes(event.target.value);
															this.file_details.document_type =
																event.target.value;
															this.file_details.form_type = 0;
														}
													">
													<option
														disabled
														selected>
														Choose Document Type
													</option>
													<option
														v-for="(opt, x) in this.menu"
														:selected="x == this.file_details.document_type">
														{{ x }}
													</option>
												</select>
											</div>
										</div>
									</div>
									<div class="field">
										<label class="heading">Form Type</label>
										<div class="control">
											<div class="select is-fullwidth">
												<select
													v-on:change="
														(event) => {
															this.file_details.form_type = event.target.value;
														}
													">
													<option
														:selected="this.file_details.form_type == 0"
														disabled>
														Choose form type
													</option>
													<option
														v-for="item in this.form_types"
														:selected="item == this.file_details.form_type">
														{{ item }}
													</option>
												</select>
											</div>
										</div>
									</div>
									<div class="field">
										<label class="heading">Payment</label>
										<div class="control">
											<div class="select is-fullwidth">
												<select
													v-on:change="
														(event) => {
															this.file_details.payment = event.target.value;
														}
													">
													<option
														:selected="this.file_details.form_type == 0"
														disabled>
														Choose form type
													</option>
													<option
														v-for="item in ['PENDING', 'COMPLETED']"
														:selected="item == this.file_details.payment">
														{{ item }}
													</option>
												</select>
											</div>
										</div>
									</div>

									<div class="field">
										<label class="heading">Status</label>
										<div class="control">
											<div class="select is-fullwidth">
												<select
													v-on:change="
														(event) => {
															this.file_details.status = event.target.value;
														}
													">
													<option
														:selected="this.file_details.form_type == 0"
														disabled>
														Choose form type
													</option>
													<option
														v-for="item in [
															'PENDING',
															'REVIEW',
															'COMPLETED',
														]"
														:selected="item == this.file_details.status">
														{{ item }}
													</option>
												</select>
											</div>
										</div>
									</div>

									<div class="field">
										<label class="heading">Date</label>
										<div class="control">
											<input
												class="input"
												v-model="this.file_details.date"
												type="date" />
										</div>
									</div>
									<div class="field">
										<div class="control buttons">
											<button
												class="button is-danger"
												@click="ArchiveFile(this.file_details.file_id)">
												<span class="icon is-small">
													<i class="fas fa-archive"></i>
												</span>
												<span> Archive </span>
											</button>
											<button
												class="button is-success"
												@click="UpdateFile()">
												<span class="icon is-small">
													<i class="fas fa-check"></i>
												</span>
												<span> Submit </span>
											</button>
										</div>
									</div>
								</div>
								<div class="column is-auto">
									<DragAndDropFileVue :FileToParent="FileToParent" />
								</div>
							</div>
						</div>
						<!-- ARCHIVED FILES  -->
						<div v-else-if="this.panel == 'archived_files'">
							<table class="table is-fullwidth">
								<thead>
									<tr>
										<th>Name</th>
										<th>Document Type</th>
										<th>Form Type</th>
										<th>Date</th>
										<th>Status</th>
										<th>Payment</th>
										<th>Actions</th>
									</tr>
								</thead>
								<tbody>
									<tr
										v-for="(file, i) in this.archived_files"
										:key="i">
										<th>{{ file.name }}</th>
										<th>{{ file.document_type }}</th>
										<th>{{ file.form_type }}</th>
										<th>{{ file.date }}</th>
										<th>{{ file.status }}</th>
										<th>{{ file.payment }}</th>
										<th>
											<button
												class="button tag is-info mb-1"
												@click="RestoreFile(file.file_id)">
												<span class="icon is-small">
													<i class="fas fa-refresh"></i>
												</span>
												<span>Restore</span>
											</button>
										</th>
									</tr>
								</tbody>
							</table>
						</div>
						<div v-else-if="this.panel == 'file_history'">
							<table class="table is-fullwidth">
								<thead>
									<tr>
										<th>Name</th>
										<th>File Name</th>
										<th>Version</th>
										<th>Actions</th>
									</tr>
								</thead>
								<tbody>
									<tr
										v-for="(file, i) in this.history_files"
										:key="count">
										<th>{{ file.name }}</th>
										<th>{{ file.file_name }}</th>

										<th>{{ file.version }}</th>
										<th>
											<button
												class="button is-small is-info"
												@click="DownloadFile(file.file_name)">
												Download
											</button>
										</th>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</template>
	</PageTemplate>
</template>
